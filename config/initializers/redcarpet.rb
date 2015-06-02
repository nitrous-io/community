require 'redcarpet'

renderer  = Redcarpet::Render::HTML.new({ filter_html: true, hard_wrap: true, prettify: true })
$markdown = Redcarpet::Markdown.new(renderer, { fenced_code_blocks: true, autolink: true, strikethrough: true })