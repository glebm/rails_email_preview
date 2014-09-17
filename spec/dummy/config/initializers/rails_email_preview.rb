require 'rails_email_preview'

RailsEmailPreview.view_hooks.add_render :headers_and_nav, :before, partial: 'rails_email_preview/my_hook', locals: {pos: 'before headers_and_nav'}
RailsEmailPreview.view_hooks.add_render :headers_content, :after, partial: 'rails_email_preview/my_hook', locals: {pos: 'after headers_content'}

Rails.application.config.to_prepare do
  # # If you use a *custom layout*, make route helpers available to REP:
  # RailsEmailPreview.inline_main_app_routes!
  # Auto-load preview classes from:
  RailsEmailPreview.preview_classes = Dir[Rails.root.join 'app/mailer_previews/*_preview.rb'].map { |p|
    File.basename(p, '.rb').camelize
  }
end
