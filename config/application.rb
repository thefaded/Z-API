require_relative 'boot'
require_relative '../lib/authentication/token_strategy.rb'
require_relative '../lib/authentication/response_token.rb'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ZApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Use sidekiq
    config.active_job.queue_adapter = :sidekiq
    # Add delay methods
    Sidekiq::Extensions.enable_delay!

    # Add /lib folder to autload
    config.autoload_paths += %W[#{config.root}/lib]

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # Middleware for ActiveAdmin
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Flash
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore

    # Warden
    config.middleware.use Warden::Manager do |manager|
      Warden::Strategies.add(:basic_auth_terminal, Authentication::Strategies::BasicAuthTerminalStrategy)
      Warden::Strategies.add(:jwt, Authentication::Strategies::JwtTokenStrategy)

      # manager.default_strategies(scope: :user).unshift(:jwt, :basic_auth_terminal)
      # manager.default_strategies(:jwt, :basic_auth_terminal)

      manager.failure_app = proc do |_env|
        ['401', { 'Content-Type' => 'application/json' }, { error: 'x Unauthorized x', code: 401 }.to_json]
      end
    end

    Rack::Utils.multipart_part_limit = 512
    # Middleware to set response token
    # config.middleware.use Authentication::ResponseToken
  end
end
