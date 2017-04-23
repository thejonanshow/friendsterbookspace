source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "rails", "~> 5.0.2"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jquery-rails", "~> 4.3"
gem "jbuilder", "~> 2.5"
gem "redis", "~> 3.0"
gem "rspec-rails", "~> 3.5"
gem "omniauth-google-oauth2", "~> 0.4"
gem "faker", "~> 1.7"
gem "fabrication", "~> 2.16"
gem "ejs", "~> 1.1"
gem "faraday", "~> 0.11"
gem "dotenv", "~> 2.2"

group :development, :test do
  gem "pry-byebug", "~> 3.4"
  gem "webmock", "~> 3.0"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
end
