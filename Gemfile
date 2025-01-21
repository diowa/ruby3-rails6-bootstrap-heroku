# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.6'

gem 'rails', '6.1.7.10'

gem 'bootsnap', '~> 1.18', require: false
gem 'concurrent-ruby', '< 1.3.5' # rails/rails#54260
gem 'newrelic_rpm', '~> 9.16'
gem 'pg', '~> 1.4.6'
gem 'puma', '~> 6.5'
gem 'shakapacker', '8.1.0'
gem 'slim-rails', '~> 3.7'
gem 'turbo-rails', '~> 2.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
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
  gem 'rack-timeout', '~> 0.7.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', '~> 1.2019', platforms: %i[mingw mswin x64_mingw jruby]
