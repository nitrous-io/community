class TutorialsController < ApplicationController
  before_action :authenticate_admin, :only => [:new, :create]

  def new
    @tutorial = Tutorial.new
  end

  def create
    @tutorial = Tutorial.new(tutorial_params)
    @tutorial.user_id = session[:user_id]
    @tutorial.author = session[:username]
    @tutorial.admin = session[:admin]
    @tutorial.content_html = MarkdownService.new(params[:tutorial][:content_markdown]).convert_to_html

    if @tutorial.save
      flash[:success] = "Tutorial has been submitted"
      redirect_to root_path 
    else 
      flash[:error] = "Unable to submit tutorial"
      render :new
    end
  end

  def index
    @tutorials = Tutorial.all
  end

  def show
    @tutorial = Tutorial.friendly.find(params[:slug])
  end

  private

  def tutorial_params
    params.require(:tutorial).permit(:title, :content_markdown)
  end
end
