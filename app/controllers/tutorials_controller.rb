require_relative './content_controller'

class TutorialsController < ContentController
  def show
    super
    @comment = Comment.new
    @comments = @content.comments
  end

  protected
  def model_class
    Tutorial
  end

  def permitted_params
    %i(title content_markdown tag_list cover_image_url published_at)
  end
end
