source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'foreman'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'bullet'
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'yard'
  gem 'simplecov', require: false
  gem 'codecov', require: false
  gem 'webmock'
end

group :development do
  gem 'brakeman', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false

  gem 'guard-rspec', require: false
  gem 'guard-rubocop'
  gem 'letter_opener'
end

group :test do
  gem 'database_rewinder'
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'poltergeist'
  gem 'timecop'
  gem 'json_expressions'
end

gem 'config'
gem 'aws-sdk-rails'
gem 'aws-sdk-s3'
gem 'kaminari'

gem 'faraday'
gem 'faraday_middleware'

gem 'redis-actionpack'
gem 'yui-compressor'

gem 'rails-i18n'
gem 'ridgepole'
gem 'unicorn'
gem 'enum_help'
gem 'virtus'
gem 'paranoia'
gem 'whenever'

gem 'typhoeus'

# donkey-oauth2 の依存
gem 'oauth2'
gem 'json-jwt'

gem 'slim-rails'
gem 'request_store'
gem 'faker', require: false
gem 'http_accept_language'

# fs private gem
# Privateリポジトリを使う場合、下記のような環境変数を追加する必要がある。
# ex. export BUNDLE_GITHUB__COM=abcd0123generatedtoken:x-oauth-basic
#     https://bundler.io/man/bundle-config.1.html#CONFIGURATION-KEYS
fs_git = ->(git_name) { "https://github.com/f-scratch/#{git_name}" }

gem 'donkey-oauth2', git: fs_git['donkey-oauth2.git'], branch: 'v3'
gem 'fs-multidb', git: fs_git['fs-multidb.git'], tag: 'v1.2.0.pre1'
gem 'fs-zeldalogging', git: fs_git['fs-zeldalogging.git'], branch: 'v2'
gem 'fs-resourcekeeper', git: fs_git['fs-resourcekeeper.git'], branch: 'v3'

gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-swagger-ui'

gem 'lograge'
gem 'grape_logging'
gem 'sentry-raven'

gem 'admin', path: 'admin'
