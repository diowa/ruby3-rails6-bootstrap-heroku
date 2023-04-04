# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.6'
gem 'rails', '6.1.7.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.4'

# Use Puma as the app server
gem 'puma', '~> 6.2'

# Transpile app-like JavaScript. Read more: https://github.com/shakacode/shakapacker
gem 'shakapacker', '6.6.0'

# Turbo makes navigating your web application faster. Read more: https://github.com/hotwired/turbo-rails
gem 'turbo-rails', '~> 1.4'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '~> 1.16', require: false

# Template Engine
gem 'slim-rails', '~> 3.6'

# App monitoring
gem 'newrelic_rpm', '~> 9.1'

group :development, :test do
  gem 'byebug', '~> 11.1', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.1'
  gem 'pry', '~> 0.14.2'
  gem 'pry-byebug', '~> 3.10'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rspec-rails', '~> 6.0'
  gem 'rubocop', '~> 1.49', require: false
  gem 'rubocop-performance', '~> 1.16', require: false
  gem 'rubocop-rails', '~> 2.18', require: false
  gem 'rubocop-rspec', '~> 2.19', require: false
  gem 'slim_lint', '~> 0.24.0', require: false
end

group :development do
  gem 'listen', '~> 3.8'
  gem 'spring', '~> 4.1'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'spring-watcher-listen', '~> 2.1'
  gem 'web-console', '~> 4.2'
end

group :test do
  gem 'capybara', '~> 3.38'
  gem 'email_spec', '~> 2.2'
  gem 'selenium-webdriver', '~> 4.8'
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov-lcov', '~> 0.8.0', require: false
  gem 'webmock', '~> 3.18', require: false
end

group :production do
  gem 'rack-timeout', '~> 0.6.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2019', platforms: %i[mingw mswin x64_mingw jruby]
