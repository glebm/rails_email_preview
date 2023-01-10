# Configure Rails Environment
ENV['RAILS_ENV'] = ENV['RACK_ENV'] = 'test'
if ENV['COVERAGE'] && !%w(rbx jruby).include?(RUBY_ENGINE) && !ENV['MIGRATION_SPEC']
  require 'simplecov'
  SimpleCov.command_name 'RSpec'
end

require File.expand_path('../dummy/config/environment.rb', __FILE__)

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'fileutils'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

require 'capybara/cuprite'

browser_path = ENV['CHROMIUM_BIN'] || %w[
  /usr/bin/chromium-browser
  /snap/bin/chromium
  /Applications/Chromium.app/Contents/MacOS/Chromium
  /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome
].find { |path| File.executable?(path) }

Capybara.register_driver :cuprite do |app|
  options = {
    window_size: [800, 800],
    timeout: 15,
  }
  options[:browser_path] = browser_path if browser_path
  Capybara::Cuprite::Driver.new(app, options)
end

Capybara.javascript_driver = ENV['CAPYBARA_JS_DRIVER']&.to_sym || :cuprite
Capybara.asset_host = ENV['CAPYBARA_ASSET_HOST'] if ENV['CAPYBARA_ASSET_HOST']
Capybara.configure do |config|
  config.run_server = true
  config.server_port = 7000
  config.default_max_wait_time = 10
end

RSpec.configure do |config|
  config.include SaveScreenshots
  config.include WithLayout

  config.around(:each) do |ex|
    Dir.chdir(Rails.root) { ex.run }
  end
end

Rails.backtrace_cleaner.remove_silencers!
