module SharedParent
  extend ActiveSupport::Concern
  included do
    attr_reader :parent
    before_filter :get_parent
  end

  protected
  def get_parent
    if params[:post_id]
      @parent = Post.find(params[:post_id])
    elsif params[:tutorial_id]
      @parent = Tutorial.find(params[:tutorial_id])
    else
      flash[:error] = 'Unexpected error has occurred'
      redirect_to root_path
    end
  end

  def like_path
    @_parent_like_url ||= begin
      if params[:post_id]
        post_likes_path(id: @parent.id)
      elsif params[:tutorial_id]
        tutorial_likes_path(id: @parent.id)
      end
    end
  end

  def parent_show_path
    @_parent_show_url ||= begin
      if params[:post_id]
        posts_slugged_path(slug: @parent.slug)
      elsif params[:tutorial_id]
        tutorials_slugged_path(slug: @parent.slug)
      end
    end
  end
end