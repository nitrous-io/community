class ContentController < ApplicationController
  include Pageable
  before_action :verify_can_edit, except: %i(index show like unlike new)
  before_action :verify_can_edit_new, only: %i(new)
  before_action :verify_logged_in, only: %i(like unlike)

  def new
    @content = model_class.new
    @small_nav_title = 'Draft'
  end

  def create
    @content = model_class.new(content_params)
    @content.user_id = current_user.id

    if @content.save
      flash[:success] = "#{model_name.capitalize} has been created"
      redirect_to action: 'show', slug: @content.slug
    else
      flash[:error] = "Unable to create #{model_name}"
      render :new
    end
  end

  def edit
    @content = model_class.find(params[:id].to_i)
    @small_nav_title = 'Edit'
  end

  def update
    @content = model_class.find(params[:id].to_i)

    if @content.present? && @content.update_attributes(content_params)
      if params[:publish] == 'true'
        if do_publish
          flash[:success] = "#{model_name.capitalize} has been published"
          redirect_to action: 'show', slug: @content.slug
        else
          flash[:error] = "Unable to publish #{model_name}"
          redirect_to :back
        end
        return
      else
        flash[:success] = "#{model_name.capitalize} has been updated"
        redirect_to action: 'show', slug: @content.slug
        return
      end
    end

    flash[:error] = "Unable to update #{model_name}"
    render :edit
  end

  def index
    content = params[:tag] ? model_class.published.tagged_with(params[:tag]) : model_class.published
    @content = content.recently_published.page(page).per(per_page)
  end

  def show
    @content = collection.friendly.find(params[:slug])
    @is_upvoted = @content.is_upvoted_by?(current_user_id)
  end

  def destroy
    @content = model_class.find(params[:id].to_i)
    if @content.present? && @content.deleted!
      flash[:success] = "#{model_name.capitalize} has been deleted"
      redirect_to action: 'index'
    else
      flash[:error] = "Unable to delete #{model_name}"
      redirect_to :back
    end
  end

  def publish
    @content = model_class.find(params[:id].to_i)
    if do_publish
      flash[:success] = "#{model_name.capitalize} has been published"
      redirect_to action: 'show', slug: @content.slug
    else
      flash[:error] = "Unable to publish #{model_name}"
      redirect_to :back
    end
  end

  def unpublish
    @content = model_class.find(params[:id].to_i)
    if @content.present? && @content.unpublish
      flash[:success] = "#{model_name.capitalize} has been unpublished"
      redirect_to action: 'show', slug: @content.slug
    else
      flash[:error] = "Unable to unpublish #{model_name.capitalize}"
      redirect_to :back
    end
  end

  def like
    @content = model_class.find(params[:id].to_i)
    is_upvoted = @content.is_upvoted_by?(current_user_id)
    score = is_upvoted ? @content.score : @content.upvote(current_user_id)
    render json: { score: score }
  end

  def unlike
    @content = model_class.find(params[:id].to_i)
    score = @content.downvote(current_user_id)
    render json: { score: score }
  end

  protected
  def model_class
    raise NotImplementedError
  end

  def model_param_name
    model_class.to_s.downcase.to_sym
  end

  def model_name
    model_class.to_s.downcase
  end

  def permitted_params
    raise NotImplementedError
  end

  def content_params
    params.require(model_param_name).permit(permitted_params)
  end

  def collection
    @_collection ||= current_user.try(:admin?) || current_user.try(:editor) ? model_class.unscoped : model_class.published
  end

  def do_publish
    published_at = params[model_param_name] ? params[model_param_name][:published_at] : nil
    @content.present? && @content.publish_with({}, published_at)
  end
end
