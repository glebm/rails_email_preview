require 'rails_email_preview'

RailsEmailPreview.view_hooks.add_render :headers_and_nav, :before, partial: 'rails_email_preview/my_hook', locals: {pos: 'before headers_and_nav'}
RailsEmailPreview.view_hooks.add_render :headers_content, :after, partial: 'rails_email_preview/my_hook', locals: {pos: 'after headers_content'}

Rails.application.config.to_prepare do
  RailsEmailPreview.preview_classes = RailsEmailPreview.find_preview_classes(Rails.root.join 'app/mailer_previews')
end
