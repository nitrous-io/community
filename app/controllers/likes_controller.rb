class LikesController < ApplicationController
  before_action :verify_logged_in

  def create
    user_id = session[:user_id]
    post_id = params[:post_id]

    if user_has_liked?(user_id, post_id)
      flash[:error] = "You have already sent hearts on this post."
    else
      liked = LikeService.new.like(user_id, post_id)
      if liked 
        flash[:success] = "Thank you for sending hearts!"
      else
        flash[:error] = "Sorry, an error occurred. Please try again."
      end
    end

    # TODO: Use AJAX.
    redirect_to posts_slugged_path(slug: params[:slug])
  end

  private

  def user_has_liked?(user_id, post_id)
    return Like.where(user_id: user_id, post_id: post_id).exists?
  end

end
