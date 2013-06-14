require 'rails_email_preview'

# Add this to process preview with premailer-rails
# RailsEmailPreview.before_render { |message| Premailer::Rails::Hook.delivering_email(message) }

# with actionmailer-inline-css
# RailsEmailPreview.before_render { |message| ActionMailer::InlineCssHook.delivering_email(message) }

Rails.application.config.to_prepare do
  # Choose where to load preview_classes from:
  RailsEmailPreview.preview_classes = Dir['app/mailer_previews/*_preview.rb'].map { |p|
    File.basename(p, '.rb').camelize
  }

  # Use a custom layout
  # RailsEmailPreview::ApplicationController.layout 'admin'

  # Add authorization
  # RailsEmailPreview::ApplicationController.module_eval do
  #   before_filter :check_permissions
  #   private
  #   def check_permissions
  #     render status: 403 unless current_user.try(:admin?)
  #   end
  # end
end

# Uncomment this to enable comfortable_mexican_sofa integration
# require 'rails_email_preview/integrations/comfortable_mexica_sofa'
