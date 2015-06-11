class CommentsController < ApplicationController
  before_action :verify_logged_in

  include SharedParent

  def create
    comment = parent.comments.build(comment_params)
    comment.user_id = current_user.id

    locals = { comments: parent.comments, create_comment_path: create_comment_path }
    if comment.save
      locals[:comment] = Comment.new
    else
      locals[:comment] = comment
    end

    render partial: 'partials/comments_with_form', locals: locals
  end

  private 

  def comment_params
    params.require(:comment).permit(:content)
  end
end
