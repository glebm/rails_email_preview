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

load 'tasks/i18n-tasks.rake'

task default: :spec
