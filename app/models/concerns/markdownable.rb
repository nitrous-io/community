module Markdownable
  extend ActiveSupport::Concern

  included do
    before_save :set_html_from_markdown
  end

  def set_html_from_markdown
    self.content_html = MarkdownService.new.render(self.content_markdown)
    self.content_text = HTMLStripper.strip(self.content_html)
  end
end

class HTMLStripper
  include ActionView::Helpers::SanitizeHelper
  
  def self.strip(html)
    new.strip_tags(html)
  end
end