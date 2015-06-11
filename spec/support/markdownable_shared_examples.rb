require 'rails_helper'

shared_examples 'markdownable' do
  it 'sets convert markdown content to html' do
    subject.content_markdown = '1. content'
    subject.save
    expect(subject.content_html).to eq("<ol>\n<li>content</li>\n</ol>\n")

  end

  it 'sets convert markdown content to text' do
    subject.content_markdown = '* content'
    subject.save
    expect(subject.content_text).to eq('content')
  end
end