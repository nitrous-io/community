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

    if @tutorial.present? && @tutorial.update_attributes(tutorial_params)
      flash[:success] = 'Tutorial has been updated'
      redirect_to tutorial_path(@tutorial)
      return
    end

    flash[:error] = 'Unable to update tutorial'
    render :edit
  end

  def index
    tutorials = params[:tag] ? Tutorial.published.tagged_with(params[:tag]) : Tutorial.published
    @tutorials = tutorials.recently_published.page(page).per(per_page)
  end

  def show
    @tutorial = collection.friendly.find(params[:slug])
    @is_upvoted = @tutorial.is_upvoted_by?(current_user_id)
    @comment = Comment.new
    @comments = @tutorial.comments
  end

  def destroy
    @tutorial = Tutorial.find(params[:id].to_i)
    if @tutorial.present? && @tutorial.deleted!
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

    if @tutorial.present? && @tutorial.publish_with({}, published_at)
      flash[:success] = 'Tutorial has been published'
      redirect_to tutorial_path(@tutorial)
    else
      flash[:error] = 'Unable to publish tutorial'
      redirect_to :back
    end
  end

  def unpublish
    @tutorial = Tutorial.find(params[:id].to_i)
    if @tutorial.present? && @tutorial.unpublish
      flash[:success] = 'Tutorial has been unpublished'
      redirect_to tutorial_path(@tutorial)
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
