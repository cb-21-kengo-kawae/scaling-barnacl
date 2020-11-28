require_relative 'boot'

require "rails/all"
# require "rails/test_unit/railtie"
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ZeldaTemplate4th
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.autoloader = :classic

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.eager_load_paths += %w(
      app/usecases
      app/services
      lib/app
    ).map { |path| "#{config.root}/#{path}" }

    config.relative_url_root = "/#{Settings.service_name}" unless Rails.env.test?

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.i18n.load_path += Dir[
      Rails.root.join('config', 'locales', '**', '*.{rb,yml}'),
      Rails.root.join('admin', 'config', 'locales', '**', '*.{rb,yml}')
    ]
  end
end
