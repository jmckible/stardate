source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'bcrypt'
gem 'bootsnap', require: false
gem 'haml'
gem 'image_processing'
gem 'importmap-rails'
gem 'pg'
gem 'propshaft', github: 'rails/propshaft'
gem 'puma'
gem 'rails', '7.1.2'
gem 'solid_cache'
gem 'stimulus-rails'
gem "turbo-rails", "= 2.0.0.pre.beta.2"
gem 'will_paginate'

group :development, :test do
  gem 'dockerfile-rails', '>= 1.6' # For rails generate dockerfile
  gem 'haml_lint'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-rails', require: false
end

group :development do
  gem 'listen'
  gem 'web-console'
end

group :test do
  gem 'rails-controller-testing'
end
