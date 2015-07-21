module S3HttpsForceable
  extend ActiveSupport::Concern

  NITROUS_S3_HTTP_PREFIX_REGEX = /http:\/\/nitrous-community\.s3\./
  NITROUS_S3_HTTPS_PREFIX = 'https://nitrous-community.s3.'

  included do
    before_save :use_https_s3
  end

  def use_https_s3
    %i(content_markdown cover_image_url).each do |col|
      content = self.send(col)
      if content.present?
        self.send("#{col}=".to_sym, content.gsub(NITROUS_S3_HTTP_PREFIX_REGEX, NITROUS_S3_HTTPS_PREFIX))
      end
    end
  end
end
