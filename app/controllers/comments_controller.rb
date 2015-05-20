class CommentsController < ApplicationController
  before_action :verify_logged_in

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params)
    comment.author = current_user.username

    if comment.save
      flash[:success] = "Your comment has been posted"
    else
      flash[:error] = "Your comment has not been posted"
    end

    redirect_to posts_slugged_path(slug: params[:slug])
  end

  private 

  def comment_params
    params.require(:comment).permit(:content)
  end
end
