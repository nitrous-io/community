require_relative './content_controller'

class PostsController < ContentController
  def index
    super
    if params[:tag].blank?
      content = @content
      @content = content.padding(1)
      @cover_content = content.recently_published.limit(1)[0] if @_page == 1
    end
  end

  protected
  def model_class
    Post
  end

  def permitted_params
    %i(title content_markdown tag_list cover_image_url)
  end
end
