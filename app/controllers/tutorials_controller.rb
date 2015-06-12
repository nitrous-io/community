class TutorialsController < ApplicationController
  include Pageable
  before_action :verify_admin, except: %i(index show)

  def new
    @tutorial = Tutorial.new
    @small_nav_title = 'Draft'
  end

  def create
    @tutorial = Tutorial.new(tutorial_params)
    @tutorial.user_id = current_user.id

    if @tutorial.save
      flash[:success] = 'Tutorial has been uploaded'
      redirect_to drafts_path
    else
      flash[:error] = 'Unable to upload tutorial'
      render :new
    end
  end

  def edit
    @tutorial = Tutorial.find(params[:id])
    @small_nav_title = 'Edit'
  end

  def update
    @tutorial = Tutorial.find(params[:id].to_i)

    if params[:publish] == 'true'
      if @tutorial.publish_with(tutorial_params, params[:tutorial][:published_at])
        flash[:success] = 'Tutorial has been published'
        redirect_to tutorials_path
        return
      end
    else
      if @tutorial.update_attributes(tutorial_params)
        flash[:success] = 'Tutorial has been updated'
        if @tutorial.published?
          redirect_to tutorials_path
        else
          redirect_to drafts_path
        end
        return
      end
    end

    flash[:error] = 'Unable to update tutorial'
    render :edit
  end

  def index
    @tutorials = params[:tag] ? Tutorial.published.tagged_with(params[:tag]) : Tutorial.published
    @tutorials = @tutorials.by_published_at.page(page).per(per_page)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def show
    @tutorial = collection.friendly.find(params[:slug])
    @is_upvoted = @tutorial.is_upvoted_by?(current_user_id)
    @comment = Comment.new
    @comments = @tutorial.comments
  end

  def destroy
    @tutorial = Tutorial.find(params[:id].to_i)
    if @tutorial && @tutorial.deleted!
      flash[:success] = 'Tutorial has been deleted'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to delete tutorial'
      redirect_to :back
    end
  end

  def publish
    @tutorial = Tutorial.find(params[:id].to_i)
    published_at = params[:tutorial] ? params[:tutorial][:published_at] : nil
    if @tutorial.publish_with({}, published_at)
      flash[:success] = 'Tutorial has been published'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to publish tutorial'
      redirect_to :back
    end
  end

  def unpublish
    @tutorial = Tutorial.find(params[:id].to_i)
    if @tutorial.unpublish
      flash[:success] = 'Tutorial has been unpublished'
      redirect_to drafts_path
    else
      flash[:error] = 'Unable to unpublish tutorial'
      redirect_to :back
    end
  end

  protected
  def tutorial_params
    params.require(:tutorial).permit(:title, :content_markdown, :tag_list, :cover_image_url)
  end

  def collection
    @collection ||= current_user.try(:admin?) ? Tutorial.unscoped : Tutorial.published
  end
end
