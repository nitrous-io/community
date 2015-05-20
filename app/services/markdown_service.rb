class MarkdownService
  class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  def initialize
    options = { filter_html: true, hard_wrap: true, prettify: true }
    extensions = { fenced_code_blocks: true, autolink: true, strikethrough: true }

    renderer = HTML.new(options)
    @markdown = Redcarpet::Markdown.new(renderer, extensions)
  end

  def convert_to_html(markdown_text)
    @markdown.render(markdown_text)
  end
end
