source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'foreman', '~> 0.78.0'

# Use postgresql as the database for Active Record
gem 'pg'

# HTTP requests
gem 'httparty'

# Session store backed by Active Record class.
gem 'activerecord-session_store'

# Generate pretty-URL
gem 'friendly_id', '~> 5.1.0'

# Markdown to HTML
gem 'redcarpet'
# Syntax highlighting
gem 'rouge'

# Tagging
gem 'acts-as-taggable-on', '~> 3.4'

# Image upload with drag and drop
gem 'carrierwave'
# Upload to s3
gem 'fog'

# Front-end stack
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'
gem 'bootstrap-sass'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc

group :development, :test do
  gem 'factory_girl_rails'
  gem 'byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'shoulda-matchers', require: false
  gem 'spring-commands-rspec'
  gem 'dotenv-rails', '~> 2.0.1'
  gem 'pry-rails'
end

group :test do
  gem 'webmock', '~> 1.21.0'
  gem 'timecop', '~> 0.7.3'
end

group :production do
  gem 'unicorn', '~> 4.8.3'
end
