module Markdownable
  extend ActiveSupport::Concern

  included do
    before_save :set_html_from_markdown
  end

  def set_html_from_markdown
    self.content_html = markdown.render(self.content_markdown)
  end

  protected
  def markdown
    @_markdown ||= begin
      renderer  = Redcarpet::Render::HTML.new({ filter_html: true, hard_wrap: true, prettify: true })
      Redcarpet::Markdown.new(renderer, { fenced_code_blocks: true, autolink: true, strikethrough: true })
    end
  end
end