require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'jquery-rails'
require 'turbolinks'
require 'bootstrap-sass'
require 'google_visualr'
require 'devise'
require 'attr_encryptor'

if Rails.env == "development"
  require 'better_errors'
  require 'binding_of_caller'
  require 'pry-remote'
  require 'pry-rails'
  require 'pry-rescue'
end

if Rails.env == "production"
  require 'memcachier'
  require 'dalli'
end


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
#Bundler.require(:default, Rails.env)

module ProgressVisualizer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.time_zone = 'Eastern Time (US & Canada)'
  end
end
