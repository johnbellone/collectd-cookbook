source 'https://rubygems.org'
gem 'codeclimate-test-reporter', group: :test
gem 'poise', '~> 2.2'
gem 'poise-service', '~> 1.0'
gem 'poise-boiler'

group :lint do
  gem 'rubocop'
  gem 'foodcritic'
end

group :unit, :integration do
  gem 'berkshelf'
  gem 'chefspec'
  gem 'test-kitchen'
  gem 'serverspec'
end

group :development do
  gem 'awesome_print'
  gem 'rake'
  gem 'stove'
end

group :doc do
  gem 'yard'
end
