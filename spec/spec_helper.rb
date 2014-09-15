# -*- encoding : utf-8 -*-
# Configure Rails Environment
ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'
unless defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
  begin
    require 'coveralls'
    Coveralls.wear! 'rails'
  rescue LoadError
    false
  end
end

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'fileutils'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

poltergeist_opts = {
    timeout:     160,
    window_size: [800, 800]
}
Capybara.register_driver(:poltergeist) { |app| Capybara::Poltergeist::Driver.new(app, poltergeist_opts) }

RSpec.configure do |config|
  Capybara.configure do |capy|
    capy.javascript_driver = :poltergeist
    capy.run_server        = true
    capy.server_port       = 7000
  end
  config.include SaveScreenshots
  config.include WithLayout

  config.around(:each) do |ex|
    Dir.chdir(Rails.root) { ex.run }
  end
end

Rails.backtrace_cleaner.remove_silencers!
