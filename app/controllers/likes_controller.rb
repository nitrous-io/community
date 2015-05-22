class LikesController < ApplicationController
  before_action :verify_logged_in

  include SharedParent

  def create
    user_id = session[:user_id]

    if parent.is_upvoted_by?(user_id)
      flash[:error] = 'You have already sent hearts on this post.'
    else
      if parent.upvote(user_id)
        flash[:success] = 'Thank you for sending hearts!'
      else
        flash[:error] = 'Sorry, an error occurred. Please try again.'
      end
    end

    redirect_to parent_show_path
  end
end
