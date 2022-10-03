require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Aeksion
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults Rails::VERSION::STRING.to_f

    config.time_zone = 'Europe/Madrid'

    config.i18n.available_locales = %i[es en]
    config.i18n.default_locale = :es
    config.i18n.fallbacks = true

    config.generators do |gen|
      gen.assets            false
      gen.helper            false
      gen.test_framework    :rspec
      gen.jbuilder          false
    end

    # to use component previews in tests
    config.view_component.preview_paths << Rails.root.join('/spec/components/previews')
  end
end
