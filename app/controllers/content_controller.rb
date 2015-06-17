class ContentController < ApplicationController
  include Pageable
  before_action :verify_admin, except: %i(index show)

  def new
    @content = model_class.new
    @small_nav_title = 'Draft'
  end

  def create
    @content = model_class.new(content_params)
    @content.user_id = current_user.id

    if @content.save
      flash[:success] = "#{model_name.capitalize} has been created"
      redirect_to drafts_path
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
      flash[:success] = "#{model_name.capitalize} has been updated"
      redirect_to action: 'show', slug: @content.slug
      return
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
    @comment = Comment.new
    @comments = @content.comments
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
    published_at = params[model_param_name] ? params[model_param_name][:published_at] : nil

    if @content.present? && @content.publish_with({}, published_at)
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
    @_collection ||= current_user.try(:admin?) ? model_class.unscoped : model_class.published
  end
end
