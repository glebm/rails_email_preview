source 'https://rubygems.org'

gemspec

gem 'rails'

group :test do
  gem 'simplecov', require: false
end

platform :rbx do
  gem 'rubysl', '~> 2.0'
  gem 'racc'
end

unless ENV['TRAVIS']
  group :test, :development do
    gem 'byebug', platform: :mri_21, require: false
  end

  group :development do
    gem 'puma'
  end
end
