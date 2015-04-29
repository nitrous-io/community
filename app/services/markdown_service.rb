class MarkdownService
  def initialize
    options = { filter_html: true, hard_wrap: true, prettify: true }
    extensions = {}

    renderer = Redcarpet::Render::HTML.new(options)
    @markdown = Redcarpet::Markdown.new(renderer, extensions)
  end

  def convert_to_html(markdown_text)
    @markdown.render(markdown_text)
  end
end
