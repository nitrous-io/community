require 'redcarpet'

class MarkdownService
  RENDERER_OPTION = { filter_html: true, hard_wrap: true, prettify: true }
  MARKDOWN_OPTION = { fenced_code_blocks: true, autolink: true, strikethrough: true }

  def render(markdown_text)
    markdown.render(markdown_text)
  end

  def markdown
    @_markdown ||= begin
      renderer  = Redcarpet::Render::HTML.new(RENDERER_OPTION)
      Redcarpet::Markdown.new(renderer, MARKDOWN_OPTION)
    end
  end
end
