source 'https://rubygems.org'
ruby '2.0.0'
gem 'rails', '4.0.0'
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'
gem 'bootstrap-sass', '~> 2.3.2.2'
gem 'figaro'
gem 'haml-rails'
gem 'simple_form', '>= 3.0.0.rc'
gem 'snoo'

group :assets do
  gem 'therubyracer', :platform=>:ruby
end
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', :platforms=>[:mri_19, :mri_20, :rbx]
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'rails_layout'
  gem 'rb-fchange', :require=>false
  gem 'rb-fsevent', :require=>false
  gem 'rb-inotify', :require=>false
end
group :development, :test do
  # We're not even persisting data (yet), leave it here until I decide
  # to start saving stuff
  gem 'sqlite3'

  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'dotenv-rails'
end
group :test do
  gem 'database_cleaner', '1.0.1'
  gem 'email_spec'
end

group :production do
  # We're not even persisting data (yet), leave it here until I decide
  # to start saving stuff
  gem "pg"
  gem 'passenger', '>= 4.0.18'
end
