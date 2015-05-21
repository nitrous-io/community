class LikesController < ApplicationController
  before_action :verify_logged_in

  def create
    user_id = session[:user_id]
    post_id = params[:post_id]
    post = Post.find(post_id)

    if post.is_upvoted_by?(user_id)
      flash[:error] = 'You have already sent hearts on this post.'
    else
      if post.upvote(user_id)
        flash[:success] = 'Thank you for sending hearts!'
      else
        flash[:error] = 'Sorry, an error occurred. Please try again.'
      end
    end

    redirect_to posts_slugged_path(slug: post.slug)
  end
end
