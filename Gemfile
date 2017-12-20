source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'pg', '~> 0.21.0'
gem 'puma', '~> 3.7'
gem 'jbuilder', '~> 2.5'
gem 'devise_token_auth', '~> 0.1.42'
gem 'rack-cors'
gem 'apipie-rails', '~> 0.5.5'


group :development, :test do
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'rspec-rails', '~> 3.7', '>= 3.7.2'
  gem 'pry-byebug', '~> 3.5', '>= 3.5.1'
  gem 'ffaker', '~> 2.7'
  gem 'brakeman'
end

group :test do
  gem 'database_cleaner', '~> 1.6.1'
  gem 'simplecov', require: false
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
