source 'https://rubygems.org'

ruby '2.2.1'

gem 'rails', '4.2.5.1'
gem 'foreman', '~> 0.78.0'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18.2'

# HTTP requests
gem 'httparty', '~> 0.13.5'

# Session store backed by Active Record class.
gem 'activerecord-session_store', '~> 0.1.1'

# Generate pretty-URL
gem 'friendly_id', '~> 5.1.0'

# Markdown to HTML
gem 'redcarpet', '~> 3.2.3'

# Tagging
gem 'acts-as-taggable-on', '~> 3.5.0'

# Image upload with drag and drop
gem 'carrierwave', '~> 0.10.0'
# Upload to s3
gem 'fog', '~> 1.30.0'

# Front-end stack
gem 'sass-rails', '~> 5.0.3'
gem 'slim-rails', '~> 3.0.1'
gem 'autoprefixer-rails', '~> 5.2.0'
gem 'font-awesome-rails', '~> 4.3.0.0'

gem 'uglifier', '~> 2.7.1'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.3'
gem 'codemirror-rails', '~> 5.3'
gem 'textacular', '~> 3.2.2'
gem 'kaminari', '~> 0.16.3'

group :development, :test do
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'byebug', '~> 5.0.0'
  gem 'rspec-rails', '~> 3.2.1'
  gem 'web-console', '~> 2.1.2'
  gem 'spring', '~> 1.3.6'
  gem 'shoulda-matchers', '~> 2.8.0', require: false
  gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'dotenv-rails', '~> 2.0.1'
  gem 'pry-rails', '~> 0.3.4'
  gem 'konacha', '~> 4.0.0'
  gem 'poltergeist', '~> 1.6.0'
end

group :test do
  gem 'webmock', '~> 1.21.0'
  gem 'timecop', '~> 0.7.3'
  gem 'nokogiri', '~> 1.6.6.2'
end

group :production do
  gem 'unicorn', '~> 4.9.0'
  gem 'rails_12factor'
end
