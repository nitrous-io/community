class LikesController < ApplicationController
  before_action :verify_logged_in

  include SharedParent

  def create
    user_id = session[:user_id]

    if parent.is_upvoted_by?(user_id)
      flash[:error] = 'You have already sent hearts on this post.'
    else
      old_score = parent.score
      score = parent.upvote(user_id)
      if old_score < score
        flash[:success] = 'Thank you for sending hearts!'
      else
        flash[:error] = 'Sorry, an error occurred. Please try again.'
      end
    end

    render partial: 'likes/heart', locals: { score: score, url: @parent_like_path }
  end
end
