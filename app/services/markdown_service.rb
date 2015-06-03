class MarkdownService
  def initialize
    renderer  = Redcarpet::Render::HTML.new({ filter_html: true, hard_wrap: true, prettify: true })
    @markdown = Redcarpet::Markdown.new(renderer, { fenced_code_blocks: true, autolink: true, strikethrough: true })
  end

  def convert_to_html(markdown_text)
    @markdown.render(markdown_text)
  end
end
