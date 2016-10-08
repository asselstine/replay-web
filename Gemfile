source 'http://rubygems.org'

ruby '2.3.1'

gem 'virtus'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'

gem 'rollbar', git: 'https://github.com/rollbar/rollbar-gem.git', branch: 'master'
gem 'messengerjs-rails', '~> 1.4.1'
# gem 'streamio-ffmpeg'
gem 'js-routes'
gem 'i18n-js', '>= 3.0.0.rc11'
gem 'ruby_kml'
gem 'active_model_serializers', git: 'https://github.com/rails-api/active_model_serializers.git'
gem 'react-rails', '~> 1.5.0'
gem 'sprockets-coffee-react'
gem 'bootstrap-datepicker-rails'
gem 'aws-sdk', '~> 2'
gem 'resque'
gem 'react-rails-hot-loader'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'dropzonejs-rails'
gem 'devise'
gem 'omniauth-dropbox-oauth2'

gem 'bootstrap-sass', '~> 3.3.5'

gem 'exifr'
gem 'dropbox-sdk'
gem 'fog'
gem 'fog-aws'
gem 'carrierwave'
gem 'geocoder'
gem 'mini_magick'
gem 'cancancan'
gem 'slim'
gem 'simple_form'
gem 'strava-api-v3'
gem 'omniauth-strava'
gem 's3_direct_upload'

# gem 'rb-gsl', require: false
gem 'gsl', '~> 1.16'

gem 'figaro'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'puma'

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'rspec-set'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'nokogiri'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'timecop'
end

group :development, :test do
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-cucumber'
  gem 'factory_girl_rails'
  gem 'better_errors'
end

group :development do
  gem 'letter_opener'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :development, :production do
  gem 'pg'
end
