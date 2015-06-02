module Markdownable
  extend ActiveSupport::Concern

  included do
    before_save :set_html_from_markdown
  end

  def set_html_from_markdown
    self.content_html = $markdown.render(self.content_markdown)
  end
end