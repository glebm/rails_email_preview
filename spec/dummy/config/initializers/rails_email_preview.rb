require 'rails_email_preview'

Rails.application.config.to_prepare do
  # # If you use a *custom layout*, make route helpers available to REP:
  # RailsEmailPreview.inline_main_app_routes!
  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes = Dir[Rails.root.join 'app/mailer_previews/*_preview.rb'].map { |p|
    File.basename(p, '.rb').camelize
  }
end
