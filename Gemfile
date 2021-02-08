source 'https://rubygems.org'
ruby '2.7.0'

group :production do
  gem 'sinatra', '~> 2.0', '>= 2.0.8.1'
  gem 'puma', '~> 4.3'
  gem 'activerecord', '~> 6.0', '>= 6.0.3.1', require: 'active_record'
  gem 'haml', '~> 5.1', '>= 5.1.2'
  gem 'rake', '~> 13.0', '>= 13.0.1'
  gem 'sqlite3', '~> 1.4', '>= 1.4.2'
  gem 'dry-monads', '~> 1.3', '>= 1.3.5'
  gem 'dry-validation', '~> 1.5', '>= 1.5.6'
end

group :development, :test do
  gem 'sinatra-contrib', '~> 2.0', '>= 2.0.8.1'
  gem 'rspec', '~> 3.9'
  gem 'rack-test', '~> 1.1'
  gem 'factory_bot', '~> 5.1', '>= 5.1.1'
  gem 'database_cleaner-active_record', '~> 1.8'
  gem 'capybara', '~> 3.35', '>= 3.35.3'
end

group :deploy do
  gem 'provisioner', path: 'infra/provisioner'
end
