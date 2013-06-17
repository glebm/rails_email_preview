require 'rails_email_preview'

#= Premailer
#
# # process preview with premailer-rails:
# RailsEmailPreview.before_render { |message| Premailer::Rails::Hook.delivering_email(message) }
# # process preview with actionmailer-inline-css:
# RailsEmailPreview.before_render { |message| ActionMailer::InlineCssHook.delivering_email(message) }

#= Comfortable Mexican Sofa
#
# # enable comfortable_mexican_sofa integration:
# require 'rails_email_preview/integrations/comfortable_mexica_sofa'

#= Application-specific
#
# # You can specify a controller for RailsEmailPreview::ApplicationController to inherit from:
# RailsEmailPreview.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
#
# # Render REP inside a custom layout (set to 'application' to use app layout, default is REP's own layout)
# RailsEmailPreview::ApplicationController.layout 'admin'

Rails.application.config.to_prepare do
  # # If you use a *custom layout*, make route helpers available to REP:
  # RailsEmailPreview.inline_main_app_routes!

  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes = Dir['app/mailer_previews/*_preview.rb'].map { |p|
    File.basename(p, '.rb').camelize
  }
end
