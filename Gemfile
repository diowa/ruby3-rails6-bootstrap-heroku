# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.6'

gem 'rails', '6.1.7.4'

gem 'bootsnap', '~> 1.16', require: false
gem 'newrelic_rpm', '~> 9.3'
gem 'pg', '~> 1.4.6'
gem 'puma', '~> 6.3'
gem 'shakapacker', '7.0.2'
gem 'slim-rails', '~> 3.6'
gem 'turbo-rails', '~> 1.4'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'slim_lint', require: false
end

group :development do
  gem 'listen'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'email_spec'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'simplecov-lcov', require: false
  gem 'webmock', require: false
end

group :production do
  gem 'rack-timeout', '~> 0.6.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2019', platforms: %i[mingw mswin x64_mingw jruby]
