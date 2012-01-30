RailsEmailPreview::Engine.routes.draw do
  root :to => 'emails#index'
  match 'raw/:mail_class/:mail_action',
        :as => :raw_email,
        :to => 'emails#show_raw',
        :mail_class => %r([\w/]+)
  match ':mail_class/:mail_action',
        :as => :email,
        :to => 'emails#show',
        :mail_class => %r([\w/]+)
end