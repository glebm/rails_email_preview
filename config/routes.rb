RailsEmailPreview::Engine.routes.draw do
  root :to => 'emails#index'
  match 'raw/:mail_class/:mail_action(.:format)',
        :as => :raw_email,
        :to => 'emails#show_raw',
        :defaults => {:format => 'html'},
        :mail_class => %r([\w/]+)
  match ':mail_class/:mail_action(.:format)',
        :as => :email,
        :to => 'emails#show',
        :defaults => {:format => 'html'},
        :mail_class => %r([\w/]+)
end