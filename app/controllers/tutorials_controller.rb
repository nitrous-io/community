class TutorialsController < ApplicationController
  before_action :verify_admin, except: [:index, :show]

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
    @tutorials = Tutorial.active
    @tutorials = Tutorial.tagged_with(params[:tag]) if params[:tag]
  end

  def show
    @tutorial = Tutorial.active.find_by_slug(params[:slug])
    if @tutorial
      @comment = Comment.new
      @comments = @tutorial.comments
    else
      not_found
    end
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
    @tutorial = Tutorial.find_by_id(params[:id].to_i)
    if @tutorial && @tutorial.published!
      flash[:success] = 'Tutorial has been published'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to publish tutorial'
      redirect_to :back
    end
  end

  def unpublish
    @tutorial = Tutorial.find_by_id(params[:id].to_i)
    if @tutorial && @tutorial.draft!
      flash[:success] = 'Tutorial has been unpublished'
      redirect_to tutorials_path
    else
      flash[:error] = 'Unable to unpublish tutorial'
      redirect_to :back
    end
  end

  protected
  def tutorial_params
    params.require(:tutorial).permit(:title, :content_markdown, :tag_list)
  end
end
