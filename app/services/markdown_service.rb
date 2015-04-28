class MarkdownService

  def initialize(markdown_text)
    @options = { filter_html: true, hard_wrap: true, prettify: true }
    @extensions = {}
    @markdown_text = markdown_text
  end

  def convert_to_html
    renderer = Redcarpet::Render::HTML.new(@options)
    markdown = Redcarpet::Markdown.new(renderer, @extensions)
    markdown.render(@markdown_text)
  end
end
