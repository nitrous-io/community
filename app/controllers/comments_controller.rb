class CommentsController < ApplicationController
  before_action :verify_logged_in
  before_action :get_parent

  def create
    comment = @parent.comments.build(comment_params)
    comment.user_id = current_user.id

    if comment.save
      flash[:success] = 'Your comment has been posted'
    else
      flash[:error] = 'Your comment has not been posted'
    end

    redirect_to @parent_show_path
  end

  private 

  def comment_params
    params.require(:comment).permit(:content)
  end

  def get_parent
    if params[:post_id]
      @parent = Post.find(params[:post_id])
      @parent_show_path = posts_slugged_path(slug: @parent.slug)
    elsif params[:tutorial_id]
      @parent = Tutorial.find(params[:tutorial_id])
      @parent_show_path = tutorials_slugged_path(slug: @parent.slug)
    else
      flash[:error] = 'Unexpected error has occurred'
      redirect_to root_path
    end
  end
end
