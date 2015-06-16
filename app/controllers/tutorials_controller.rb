require_relative './content_controller'

class TutorialsController < ContentController
  protected
  def model_class
    Tutorial
  end

  def permitted_params
    %i(title content_markdown tag_list cover_image_url)
  end
end
