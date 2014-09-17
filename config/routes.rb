RailsEmailPreview::Engine.routes.draw do
  controller :emails do
    scope path: '(:email_locale)',
          # This constraint resolves ambiguity with :preview_id, allowing locale to be optional
          constraints: {email_locale: /#{I18n.available_locales.map(&Regexp.method(:escape)) * '|'}/},
          defaults: {email_locale: I18n.default_locale} do
      get '/' => :index, as: :rep_emails
      scope path: ':preview_id', constraints: {preview_id: /\w+-\w+/} do
        scope '(:part_type)', defaults: {part_type: 'html'} do
          get '' => :show, as: :rep_email
          get 'body' => :show_body, as: :rep_raw_email
        end
        post 'deliver' => :test_deliver, as: :rep_test_deliver
        get 'attachments/:filename' => :show_attachment, as: :rep_raw_email_attachment
        get 'headers' => :headers, as: :rep_email_headers
      end
      # alias rep_emails_url to its stable api name
      get '/' => :index, as: :rep_root
    end
  end
end
