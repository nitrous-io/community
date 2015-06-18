require_relative './content_controller'

class DocsController < ContentController
  before_action :fetch_categories, only: %i(new create edit update)
  before_action :fetch_toc, only: %i(index show)

  def index
    super if params[:tag]
  end

  protected
  def model_class
    Doc
  end

  def permitted_params
    %i(title doc_category_id content_markdown tag_list cover_image_url)
  end

  def fetch_categories
    @categories = DocCategory.ordered
  end

  def fetch_toc
    @toc = Doc.grouped(%i(title slug))
  end
end
