class TutorialsController < ApplicationController
  before_action :verify_admin, only: [:new, :create, :edit, :update]

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
    @post = Tutorial.find(params[:id])
  end

  def update
    @post = Tutorial.find(params[:id])
    if @post.update_attributes(tutorial_params)
      flash[:success] = 'Tutorial has been updated'
      redirect_to posts_path
    else
      flash[:error] = 'Unable to update tutorial'
      render :edit
    end
  end

  def index
    if params[:tag]
      @tutorials = Tutorial.tagged_with(params[:tag])
    else
      @tutorials = Tutorial.all
    end
  end

  def show
    @tutorial = Tutorial.friendly.find(params[:slug])

    @comment = Comment.new
    @comments = @tutorial.comments
  end

  protected
  def tutorial_params
    params.require(:tutorial).permit(:title, :content_markdown, :tag_list)
  end
end
