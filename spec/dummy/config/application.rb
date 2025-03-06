require File.expand_path('../boot', __FILE__)

require 'action_controller/railtie'
require 'action_mailer/railtie'

Bundler.require(*Rails.groups)
require 'rails_email_preview'

module Dummy
  class Application < Rails::Application
    config.i18n.available_locales = [:es, :en, :de, :ru]
    config.i18n.default_locale = :en
  end
end

