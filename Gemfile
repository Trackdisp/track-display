source 'https://rubygems.org'

gem 'aasm'
gem 'active_model_serializers', '~> 0.9.3'
gem 'active_skin'
gem 'activeadmin', '~> 1.3.1'
gem 'activeadmin_addons'
gem 'activejob-retry'
gem 'aws-sdk-s3', require: false
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-i18n'
gem 'elasticsearch-dsl'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'enumerize'
gem 'faraday'
gem 'friendly_id', '~> 5.1.0'
gem 'groupdate'
gem 'jbuilder', '~> 2.5'
gem 'migration_data'
gem 'mini_magick'
gem 'pg'
gem 'power-types'
gem 'puma', '~> 3.7'
gem 'pundit'
gem 'rack-cors', '~> 0.4.0'
gem 'rails', '~> 5.2.1'
gem 'rails-controller-testing'
gem 'rails-i18n'
gem 'recipient_interceptor'
gem 'responders'
gem 'sass-rails', '~> 5.0'
gem 'send_grid_mailer'
gem 'sentry-raven'
gem 'sidekiq'
gem 'sidekiq-limit_fetch'
gem 'sidekiq-scheduler'
gem 'simple_token_authentication', '~> 1.0'
gem 'spring'
gem 'uglifier', '>= 1.3.0'
gem 'versionist'
gem 'webpacker'

group :production do
  gem 'heroku-stage'
  gem 'rack-timeout'
  gem 'rails_stdout_logging'
end

group :test do
  gem 'elasticsearch-extensions'
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

group :development do
  gem 'annotate'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'guard-rspec', require: false
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-nc', require: false
  gem 'rspec-rails'
end

group :production, :development, :test do
  gem 'tzinfo-data'
end
