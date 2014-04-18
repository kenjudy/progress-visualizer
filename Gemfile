source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass', '~> 3.1.0'


# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'unicorn'

gem 'devise'

gem 'omniauth-trello'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

gem 'attr_encryptor'

gem 'mail_form'

gem 'jquery-turbolinks'

gem 'sitemap_generator'

gem 'redcarpet'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development, :test do
  gem 'spring-commands-rspec'
  gem 'rb-fsevent' if `uname` =~ /Darwin/
  gem 'rspec-rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-remote'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'terminal-notifier-guard'
  gem 'factory_girl_rails'
  gem 'lunchy'
  gem 'vcr'
  gem 'webmock'
  gem 'mailcatcher'
  gem 'capybara'
  gem 'poltergeist'
  gem 'rails_best_practices'
  gem 'metric_fu'
  gem 'database_cleaner'
end

gem "google_visualr"

group :production do
  gem 'rails_12factor'
  gem 'memcachier'
  gem 'dalli'
end

# Use debugger
# gem 'debugger', group: [:development, :test]
