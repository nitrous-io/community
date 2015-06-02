class TutorialsController < ApplicationController
  before_action :verify_admin, except: %i(index show)
  before_action :show_publish_menu, only: %i(new edit create update)

  def new
    @tutorial = Tutorial.new
  end

  def create
    @tutorial = Tutorial.new(tutorial_params)
    @tutorial.user_id = current_user.id

    if @tutorial.save
      flash[:success] = 'Tutorial has been uploaded'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to upload tutorial'
      render :new
    end
  end

  def edit
    @tutorial = Tutorial.find(params[:id])
  end

  def update
    @tutorial = Tutorial.find(params[:id])
    if @tutorial.update_attributes(tutorial_params)
      flash[:success] = 'Tutorial has been updated'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to update tutorial'
      render :edit
    end
  end

  def index
    @tutorials = params[:tag] ? Tutorial.published.tagged_with(params[:tag]) : Tutorial.published
  end

  def show
    @tutorial = collection.friendly.find(params[:slug])
    @comment = Comment.new
    @comments = @tutorial.comments
  end

  def destroy
    @tutorial = Tutorial.find(params[:id].to_i)
    if @tutorial &&@tutorial.deleted!
      flash[:success] = 'Tutorial has been deleted'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to delete tutorial'
      redirect_to :back
    end
  end

  def publish
    @tutorial = Tutorial.find(params[:id].to_i)
    published_at = params[:tutorial] && params[:tutorial][:published_at] ? params[:tutorial][:published_at] : Time.now
    if @tutorial.update_attributes(state: :published, published_at: published_at)
      flash[:success] = 'Tutorial has been published'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to publish tutorial'
      redirect_to :back
    end
  end

  def unpublish
    @tutorial = Tutorial.find(params[:id].to_i)
    if @tutorial.update_attributes(state: :draft, published_at: nil)
      flash[:success] = 'Tutorial has been unpublished'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to unpublish tutorial'
      redirect_to :back
    end
  end

  protected
  def show_publish_menu
    @edit_mode = true
  end

  def tutorial_params
    params.require(:tutorial).permit(:title, :content_markdown, :tag_list, :cover_image_url)
  end

  def collection
    @collection ||= current_user.try(:admin?) ? Tutorial.unscoped : Tutorial.published
  end
end
