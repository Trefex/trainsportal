source 'https://rubygems.org'

ruby '3.4.9'

gem 'rails', '~> 8.1'

# Database
gem 'sqlite3', '~> 2.9'

# Asset pipeline
gem 'sprockets-rails'
gem 'sassc-rails'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder'

# Web server
gem 'puma'
gem 'passenger'

# Image uploads (ActiveStorage replaces Paperclip)
gem 'image_processing', '~> 1.2'

# Icons
gem 'font-awesome-rails'

# Pagination
gem 'kaminari'

# Progress bar
gem 'progress_bar'

# Full-text search (Solr)
gem 'sunspot_rails', '~> 2.7'

# Authentication
gem 'devise'

# Date picker
gem 'bootstrap-datepicker-rails'

# Bootstrap
gem 'bootstrap-sass'

# Lightbox
gem 'lightbox2-rails'

# Seed helper
gem 'seed_dump'

# Code formatting utilities
gem 'ruby-beautify'
gem 'htmlbeautifier'

group :development do
  gem 'sunspot_solr'
  gem 'web-console'
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
end

group :development, :test do
  gem 'debug'
  gem 'minitest', '~> 6.0'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver', '>= 4.11'
  gem 'database_cleaner-active_record'
end

