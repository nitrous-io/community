require 'rails_helper'

shared_examples 's3_https_forceable' do
  it 'forces content_markdown and cover_image_url to have https s3 urls' do
    subject.content_markdown = '![lol](http://nitrous-community.s3.amazonaws.com/images/lol.jpg)'
    subject.cover_image_url = 'http://nitrous-community.s3.amazonaws.com/images/derp.png'
    subject.save

    subject.reload
    expect(subject.content_markdown).to eq('![lol](https://nitrous-community.s3.amazonaws.com/images/lol.jpg)')
    expect(subject.cover_image_url).to eq('https://nitrous-community.s3.amazonaws.com/images/derp.png')
  end
end
