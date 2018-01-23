source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'i18n', '~> 0.9.1'
gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.21.0'
gem 'puma', '~> 3.7'
gem 'jbuilder', '~> 2.5'
gem 'devise_token_auth', '~> 0.1.42'
gem 'rack-cors'
gem 'apipie-rails', '~> 0.5.5'
gem 'acts_as_list'
gem 'cancancan', '~> 2.0'
gem 'rack-cors', require: 'rack/cors'
gem 'fog-aws', '~> 1.4', '>= 1.4.1'
gem "fog-google"
gem "google-api-client", "> 0.8.5", "< 0.9"
gem 'carrierwave', '~> 1.1'
gem 'mini_magick', '~> 4.8'


group :development, :test do
  gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'pry-byebug', '~> 3.5', '>= 3.5.1'
  gem 'ffaker', '~> 2.7'
  gem 'brakeman'
  gem 'rubocop', require: false
end

group :test do
  gem 'database_cleaner', '~> 1.6.1'
  gem 'simplecov', require: false
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'json_matchers', '~> 0.7.2'
  gem 'shoulda-matchers', '~> 3.1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
