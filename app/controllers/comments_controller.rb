class CommentsController < ApplicationController
  before_action :authenticate_logged_in

  def create
    tutorial = Tutorial.new
    @comment = tutorial.comments.build(comment_params)
    @comment.author = session[:username] 
    @comment.tutorial_id = params[:tutorial_id] 

    if @comment.save
      flash[:success] = "Your comment has been posted"
    else
      flash[:error] = "Your comment has not been posted"
    end

    redirect_to tutorial_path(slug: params[:slug])
  end

  private 

  def comment_params
    params.require(:comment).permit(:content)
  end
end
