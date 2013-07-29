# encoding: utf-8
require 'rails_email_preview/engine'
require 'rails_email_preview/main_app_route_delegator'
require 'rails_email_preview/version'
require 'rails_email_preview/delivery_handler'

require 'slim'
require 'slim-rails'

module RailsEmailPreview

  mattr_accessor :parent_controller
  self.parent_controller = '::ApplicationController'

  # auto-loading configured in initializer
  mattr_accessor :preview_classes

  # send email button (experimental, false by default)
  mattr_accessor :enable_send_email
  self.enable_send_email = false

  class << self
    def run_before_render(mail, preview_class_name, mailer_action)
      (defined?(@hooks) && @hooks[:before_render] || []).each do |block|
        block.call(mail, preview_class_name, mailer_action)
      end
    end

    def before_render(&block)
      ((@hooks ||= {})[:before_render] ||= []) << block
    end

    def inline_main_app_routes!
      ::RailsEmailPreview::ApplicationController.helper ::RailsEmailPreview::MainAppRouteDelegator
    end

    def setup
      yield self
    end
  end

  # = Editing settings
  # edit link is rendered inside an iframe, so these options are provided for simple styling
  mattr_accessor :edit_link_text
  self.edit_link_text = '✎ Edit Text'
  mattr_accessor :edit_link_style
  self.edit_link_style = <<-CSS.strip.gsub(/\n+/m, ' ')
  display: block;
  font-family: Monaco, Helvetica, sans-serif;
  color: #7a4b8a;
  border: 2px dashed #7a4b8a;
  font-size: 20px;
  padding: 8px 12px;
  margin-top: 0.6em;
  margin-bottom: 0.6em;
  CSS
end
