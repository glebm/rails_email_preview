require 'rails_email_preview'

#= REP hooks and config
#RailsEmailPreview.setup do |config|
#
#  # hook before rendering preview:
#  config.before_render do |message, preview_class_name, mailer_action|
#    # apply premailer-rails:
#    Premailer::Rails::Hook.delivering_email(message)
#    # or actionmailer-inline-css:
#    ActionMailer::InlineCssHook.delivering_email(message)
#  end
#
#  # do not show Send Email button
#  config.enable_send_email = false
#end

#= REP + Comfortable Mexican Sofa integration
#
# # enable comfortable_mexican_sofa integration:
# require 'rails_email_preview/integrations/comfortable_mexica_sofa'

#= Application-specific (layout, permissions, customizations)
#
# # You can specify a controller for RailsEmailPreview::ApplicationController to inherit from:
# RailsEmailPreview.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
#
# # Render REP inside a custom layout (set to 'application' to use app layout, default is REP's own layout)
# RailsEmailPreview::EmailsController.layout 'admin'

Rails.application.config.to_prepare do
  # # If you use a *custom layout*, make route helpers available to REP:
  # RailsEmailPreview.inline_main_app_routes!

  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes = Dir[Rails.root.join 'app/mailer_previews/*_preview.rb'].map { |p|
    File.basename(p, '.rb').camelize
  }
end
