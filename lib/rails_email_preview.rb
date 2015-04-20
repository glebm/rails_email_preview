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
  self.edit_link_text = I18n.t('integrations.cms.customize_cms_for_rails_email_preview.edit_email_html')
  mattr_accessor :edit_link_style
end
