# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'bootsnap', '>= 1.4.2', require: false

gem 'capistrano'
gem 'capistrano3-puma'
gem 'capistrano-rails', require: false
gem 'capistrano-bundler', require: false
gem 'capistrano-rvm'
gem 'capistrano-yarn'

gem 'config'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'mongoid', '~> 8.0', '>= 8.0.2'
gem 'puma', '~> 4.1'
gem 'rack-cors'
gem 'rails', '~> 6.0.5', '>= 6.0.5.1'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.4.2'

gem 'net-ssh', '>= 6.0.2'
gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'
gem 'listen', '~> 3.2'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'rubocop'
end

group :development do
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'mongoid-rspec'
  gem 'rspec-rails', '~> 5.1', '>= 5.1.2'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
