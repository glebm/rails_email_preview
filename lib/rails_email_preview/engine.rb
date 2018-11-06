module ::RailsEmailPreview
  class Engine < Rails::Engine
    isolate_namespace RailsEmailPreview
    load_generators

    initializer 'rails_email_preview.setup_assets' do
      RailsEmailPreview::Engine.config.assets.precompile += %w(
        rails_email_preview/application.js
        rails_email_preview/application.css
        rails_email_preview/favicon.png
      )
    end
  end
end
