# encoding: UTF-8
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# Load dummy app tasks
if ENV['DUMMY']
  APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
  load 'rails/tasks/engine.rake'
end

Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Start development web server'
task :dev do
  require 'puma'
  require 'rails/commands/server'
  ENV['RACK_ENV'] = ENV['RAILS_ENV'] = 'development'
  Dir.chdir 'spec/dummy'
  Rack::Server.start(
      environment: 'development',
      Host: 'localhost',
      Port: 9292,
      config: 'config.ru',
      server: 'puma'
  )
end
