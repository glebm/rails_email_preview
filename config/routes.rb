RailsEmailPreview::Engine.routes.draw do
  controller :emails do
    get '/' => :index, as: :rep_emails
    scope ':preview_id', constraints: {format: /\w+-\w+/} do
      get '' => :show, as: :rep_email
      scope 'raw' do
        get '' => :show_body, as: :rep_raw_email
        get ':filename' => :show_attachment, as: :rep_raw_email_attachment
      end
      post 'deliver' => :test_deliver, as: :rep_test_deliver
      get 'headers' => :headers, as: :rep_email_headers
    end
    # alias rep_emails_url to its stable api name
    get '/' => :index, as: :rep_root
  end
end
