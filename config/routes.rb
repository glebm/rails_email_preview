RailsEmailPreview::Engine.routes.draw do
  get '/' => 'emails#index', as: :rep_emails

  get 'raw/:mail_class/:mail_action' => 'emails#show_raw', as: :rep_raw_email
  get ':mail_class/:mail_action' => 'emails#show', as: :rep_email
  post 'test_deliver/:mail_class/:mail_action' => 'emails#test_deliver', as: :rep_test_deliver

  # define alias for the root url as part of stable api
  get '/' => 'emails#index', as: :rep_root
end
