if Rails.env.development? || Rails.env.test?
  Konacha.configure do |config|
    require 'capybara/poltergeist'
    config.driver = :poltergeist
  end
end