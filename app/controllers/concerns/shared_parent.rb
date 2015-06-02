module SharedParent
  extend ActiveSupport::Concern
  included do
    attr_reader :parent, :parent_show_path
    before_filter :get_parent
  end


  protected
  def get_parent
    if params[:post_id]
      @parent = Post.find(params[:post_id])
      @parent_show_path = posts_slugged_path(slug: @parent.slug)
      @parent_like_path = post_likes_path(id: @parent.id)
    elsif params[:tutorial_id]
      @parent = Tutorial.find(params[:tutorial_id])
      @parent_show_path = tutorials_slugged_path(slug: @parent.slug)
      @parent_like_path = tutorial_likes_path(id: @parent.id)
    else
      flash[:error] = 'Unexpected error has occurred'
      redirect_to root_path
    end
  end
end