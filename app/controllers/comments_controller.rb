class CommentsController < ApplicationController
  include SharedParent

  before_action :authenticate

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

  def authenticate
    unless current_user
      session[:comment] = comment_params.merge(parent_type: parent.class.name, parent_id: parent.id)
      redirect_to login_path(return_to: request.referer)
    end
  end
end
