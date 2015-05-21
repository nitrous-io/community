class LikesController < ApplicationController
  before_action :verify_logged_in
  before_action :get_parent

  def create
    user_id = session[:user_id]

    if @parent.is_upvoted_by?(user_id)
      flash[:error] = 'You have already sent hearts on this post.'
    else
      if @parent.upvote(user_id)
        flash[:success] = 'Thank you for sending hearts!'
      else
        flash[:error] = 'Sorry, an error occurred. Please try again.'
      end
    end

    redirect_to @parent_show_path
  end

  protected
  def get_parent
    if params[:post_id]
      @parent = Post.find(params[:post_id])
      @parent_show_path = posts_slugged_path(slug: @parent.slug)
    elsif params[:tutorial_id]
      @parent = Tutorial.find(params[:tutorial_id])
      @parent_show_path = tutorials_slugged_path(slug: @parent.slug)
    else
      flash[:error] = 'Unexpected error has occurred'
      redirect_to root_path
    end
  end
end
