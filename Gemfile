source "http://rubygems.org"

gemspec

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'rubysl-test-unit', '~> 2.0'
  gem 'racc'
end

group :development, :test do
  gem 'i18n-tasks'
  gem 'capybara', '>= 0.4.0'
  gem 'rspec', '2.12.0' #, git: 'https://github.com/rspec/rspec'
  gem 'rspec-rails' #, git: 'https://github.com/rspec/rspec-rails'
  gem 'poltergeist', git: 'https://github.com/jonleighton/poltergeist'
  # a debugger that works with MRI 2.0.0
  gem 'byebug', platforms: :ruby_20
end
