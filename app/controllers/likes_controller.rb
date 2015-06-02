class LikesController < ApplicationController
  before_action :verify_logged_in

  include SharedParent

  def create
    is_upvoted = parent.is_upvoted_by?(current_user_id)
    score = is_upvoted ? parent.score : parent.upvote(current_user_id)
    render partial: 'likes/heart', locals: { score: score, url: like_path, is_upvoted: true }
  end

  def destroy
    score = parent.downvote(current_user_id)
    render partial: 'likes/heart', locals: { score: score, url: like_path, is_upvoted: false }
  end
end
