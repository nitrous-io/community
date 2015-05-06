class LikesController < ApplicationController
  before_action :verify_logged_in

  def create
    user_id = session[:user_id]
    tutorial_id = params[:tutorial_id]

    if user_has_liked?(user_id, tutorial_id)
      flash[:error] = "You have already sent hearts on this post."
    else
      liked = LikeService.new.like(user_id, tutorial_id)
      if liked 
        flash[:success] = "Thank you for sending hearts!"
      else
        flash[:error] = "Sorry, an error occurred. Please try again."
      end
    end

    # TODO: Use AJAX.
    redirect_to tutorial_path(slug: params[:slug]) 
  end

  private

  def user_has_liked?(user_id, tutorial_id)
    return Like.where(user_id: user_id, tutorial_id: tutorial_id).exists?
  end

end
