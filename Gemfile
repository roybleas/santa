source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'

# postgres database
gem 'pg', '0.18.1'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# Annotates ActiveRecord Models based on the database schema.
gem 'annotate'

#  a Sass-powered version of Bootstrap 3
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6'

group :development, :test do
  gem 'byebug'
  gem "rspec-rails", "~> 3.6.0"
  gem "factory_girl_rails", "~> 4.4.1"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :production, :development do
  gem 'puma'
  gem 'rack-timeout'
end

group :test do
  gem "faker", "~> 1.7.1"
  gem "capybara", "~> 2.4.3"
  gem "database_cleaner", "~> 1.3.0"
  gem "launchy", "~> 2.4.2"
  gem "selenium-webdriver", "~> 3.4.0"
end
