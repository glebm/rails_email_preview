# encoding: utf-8
require 'rails_email_preview/engine'
require 'rails_email_preview/main_app_route_delegator'
require 'rails_email_preview/version'
require 'rails_email_preview/delivery_handler'
require 'rails_email_preview/view_hooks'

require 'slim'
require 'slim-rails'
require 'sass'
require 'sass-rails'
require 'request_store'
require 'turbolinks'

module RailsEmailPreview

  mattr_accessor :parent_controller
  self.parent_controller = '::ApplicationController'

  # preview class names
  mattr_accessor :preview_classes

  # UI locale
  mattr_accessor :locale

  # default email locale
  mattr_accessor :default_email_locale

  # send email button
  mattr_accessor :enable_send_email
  self.enable_send_email = true

  # some easy visual settings
  mattr_accessor :style
  self.style = {
      btn_default_class:     'btn btn-default',
      btn_active_class:      'btn btn-primary active',
      btn_group_class:       'btn-group btn-group-sm',
      list_group_class:      'list-group',
      list_group_item_class: 'list-group-item',
      panel_class:           'panel panel-default',
      panel_body_class:      'panel-body',
      row_class:             'row',
      column_class:          'col-sm-%{n}'
  }

  @view_hooks = RailsEmailPreview::ViewHooks.new
  class << self
    # @return [RailsEmailPreview::ViewHooks]
    attr_reader :view_hooks
    def preview_classes=(classes)
      @preview_classes = classes
      RailsEmailPreview::Preview.load_all(classes)
    end

    def layout=(layout)
      [::RailsEmailPreview::ApplicationController, ::RailsEmailPreview::EmailsController].each { |ctrl| ctrl.layout layout }
      if layout && layout !~ %r(^rails_email_preview/)
        # inline application routes if using an app layout
        inline_main_app_routes!
      end
    end

    def run_before_render(mail, preview)
      (defined?(@hooks) && @hooks[:before_render] || []).each do |block|
        block.call(mail, preview)
      end
    end

    def before_render(&block)
      ((@hooks ||= {})[:before_render] ||= []) << block
    end

    def inline_main_app_routes!
      unless ::RailsEmailPreview::EmailsController.instance_variable_get(:@inlined_routes)
        ::RailsEmailPreview::EmailsController.helper ::RailsEmailPreview::MainAppRouteDelegator
        ::RailsEmailPreview::EmailsController.instance_variable_set(:@inlined_routes, true)
      end
    end

    def setup
      yield self
    end
  end

  # = Editing settings
  # edit link is rendered inside an iframe, so these options are provided for simple styling
  mattr_accessor :edit_link_text
  self.edit_link_text = '✎'
  mattr_accessor :edit_link_style
  self.edit_link_style = <<-CSS.strip.gsub(/\n+/m, ' ')
  -webkit-appearance: none;
  -webkit-box-shadow: rgba(255, 255, 255, 0.14902) 0px 1px 0px 0px inset, rgba(0, 0, 0, 0.0745098) 0px 1px 1px 0px;
  -webkit-rtl-ordering: logical;
  -webkit-user-select: none;
  -webkit-writing-mode: horizontal-tb;
  background-color: rgb(255, 255, 255);
  background-image: linear-gradient(rgb(255, 255, 255) 0px, rgb(224, 224, 224) 100%);
  background-repeat: repeat-x;
  border-bottom-color: rgb(204, 204, 204);
  border-bottom-left-radius: 4px;
  border-bottom-right-radius: 4px;
  border-bottom-style: solid;
  border-bottom-width: 1px;
  border-image-outset: 0px;
  border-image-repeat: stretch;
  border-image-slice: 100%;
  border-image-source: none;
  border-image-width: 1;
  border-left-color: rgb(204, 204, 204);
  border-left-style: solid;
  border-left-width: 1px;
  border-right-color: rgb(204, 204, 204);
  border-right-style: solid;
  border-right-width: 1px;
  border-top-color: rgb(204, 204, 204);
  border-top-left-radius: 4px;
  border-top-right-radius: 4px;
  border-top-style: solid;
  border-top-width: 1px;
  box-shadow: rgba(255, 255, 255, 0.14902) 0px 1px 0px 0px inset, rgba(0, 0, 0, 0.0745098) 0px 1px 1px 0px;
  box-sizing: border-box;
  color: rgb(51, 51, 51);
  cursor: pointer;
  display: inline-block;
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-size: 14px;
  font-stretch: normal;
  font-style: normal;
  font-variant: normal;
  font-weight: normal;
  height: 34px;
  letter-spacing: normal;
  line-height: 20px;
  margin-bottom: 5px;
  margin-left: 0px;
  margin-right: 0px;
  margin-top: 5px;
  padding-bottom: 6px;
  padding-left: 12px;
  padding-right: 12px;
  padding-top: 6px;
  text-align: center;
  text-indent: 0px;
  text-shadow: rgb(255, 255, 255) 0px 1px 0px;
  text-transform: none;
  touch-action: manipulation;
  vertical-align: middle;
  white-space: nowrap;
  word-spacing: 0px;
  writing-mode: lr-tb;
  text-decoration: none;
  float: right;
  CSS
end
