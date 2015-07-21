require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Community
  class Application < Rails::Application
    config.action_dispatch.session_store = :active_record_store
    config.active_record.raise_in_transactional_callbacks = true
    config.action_view.sanitized_allowed_attributes = Loofah::HTML5::WhiteList::ACCEPTABLE_ATTRIBUTES.merge(%w(autoplay muted))
  end
end
