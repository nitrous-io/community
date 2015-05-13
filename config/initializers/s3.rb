if Rails.env.production? || Rails.env.staging?

  CarrierWave.configure do |config|
    config.storage = :fog

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET'],
      :region                 => 'us-west-2'
    }
    config.fog_directory  = ENV['S3_BUCKET']
    config.fog_use_ssl_for_aws = true
  end

end

if Rails.env.development? || Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
  end
end
