source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5'
# Use sqlite3 as the database for Active Record
gem 'mysql2', '0.4.4'
# Use SCSS for stylesheets
gem 'sass-rails', '5.0.4'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '3.0.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '4.1.1'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '4.1.1'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '2.5.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '0.4.1', group: :doc

# Use Unicorn as the app server
gem 'unicorn', '5.1.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

#########################################
### default end
#########################################
#
# 本番でなぜか必要
gem 'therubyracer'
gem 'libv8'
gem 'compass', '1.0.3'
# Constant
gem 'settingslogic', '2.0.9'
# for cron
gem 'whenever', '0.9.4'
# slack
gem 'slack-notifier', '1.5.1'
# sitemap。他のprojectからコピってるならだいたい必要。Capfileで使ってる。
gem 'sitemap_generator', '5.1.0'

group :development do
  gem 'capistrano', '3.3.3'
  gem 'capistrano-rbenv'
  gem 'capistrano-rails', '1.1.3'
  gem 'pry'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-byebug' # needs ruby-2.0.0-p247
  gem 'pry-stack_explorer'
  gem 'terminal-notifier-guard'
  gem 'quiet_assets'
  gem 'html2slim'
end

# .envを自動でロードしてくれる
gem 'dotenv-rails', '2.1.1'

#########################################
### pocketpair default end
#########################################

gem 'mechanize'

#gem "selenium-webdriver", '2.45.0' これだと、firefox 44.0.1は動かない
gem 'dotenv'
gem "selenium-webdriver", '2.52.0'
gem "capybara", '2.4.4'
gem "rspec", '3.2.0'
gem "pry-byebug"
gem "poltergeist"
