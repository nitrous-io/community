module Commentable
  extend ActiveSupport::Concern

  def restore_comment(parent)
    if session[:comment]
      comment_params = session.delete(:comment)
      if comment_params[:parent_type] == parent.class.name && comment_params[:parent_id] == parent.id
        return Comment.new(content_markdown: comment_params[:content_markdown])
      end
    end
    return Comment.new
  end
end