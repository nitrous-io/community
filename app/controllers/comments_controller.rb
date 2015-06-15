class CommentsController < ApplicationController
  before_action :verify_logged_in

  include SharedParent

  def create
    comment = parent.comments.build(comment_params)
    comment.user_id = current_user.id

    if comment.save
      flash[:success] = 'Your comment has been posted'
    else
      flash[:error] = 'Your comment has not been posted'
    end

    redirect_to parent_show_path(anchor: "comment-#{comment.id}")
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
