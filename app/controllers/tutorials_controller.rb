class TutorialsController < ApplicationController
  before_action :verify_admin, only: [:new, :create]

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
