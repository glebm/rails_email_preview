Rails Email Preview 
================================

A Rails Engine to preview plain text and html email in your browser. Compatible with Rails 3 and 4.

![screenshot](http://screencloud.net//img/screenshots/749d6c6a84b5d79b436ad627902944a8.png)
*Preview UI*

How to
-----

You will need to provide data for preview of each email:

    # Say you have this mailer
    class UserMailer < ActionMailer::Base
      def invitation(inviter, invitee)
        # ...
      end

      def welcome(user)
        # ...
      end
    end

    # Define a Preview class with the same mail action names, but with no arguments
    # mkdir -p app/mailer_previews/; touch app/mailer_previews/user_mailer_preview.rb
    class UserMailerPreview
      # preview methods should return Mail objects, e.g.:
      def invitation        
        UserMailer.invitation mock_user('Alice'), mock_user('Bob')
      end
            
      def welcome                
        UserMailer.welcome mock_user                            
      end
      
      private
      def mock_user(name = 'Bill Gates')
        User.new(name: name, email: "user@test.com#{rand 100}").tap { |u| u.define_singleton_method(:id) { 123 + rand(100) } }      
      end
    end


Routing
-------
    
    mount RailsEmailPreview::Engine, at: 'email_preview' # rails_email_preview.root_url #=> '/email_preview'    


Configuration 
-------
    
    # touch config/initializers/rails_email_preview.rb

    require 'rails_email_preview'
    RailsEmailPreview.setup do |config|
      config.preview_classes = [ UserMailerPreview ]
    end

Premailer integration
---------------------

[Premailer](https://github.com/alexdunae/premailer) automatically translates standard CSS rules into old-school inline styles. Integration can be done by using the <code>before_render</code> hook.

To integrate Premailer with rails you can use either [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css) or [premailer-rails](https://github.com/fphilipe/premailer-rails).

For [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css), add to `RailsEmailPreview.setup`:
    
    config.before_render { |message| ActionMailer::InlineCssHook.delivering_email(message) }    

For [premailer-rails](https://github.com/fphilipe/premailer-rails), add to `RailsEmailPreview.setup`:
    
    config.before_render { |message| Premailer::Rails::Hook.delivering_email(message) }    

Email editing 
-------------

You can use [comfortable_mexican_sofa](https://github.com/comfy/comfortable-mexican-sofa) for storing and editing emails.
See [ComfortableMexicanSofa integration guide](https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa).

This is what it looks like:

![CMS integration screenshot](http://screencloud.net//img/screenshots/c3437edd8cdd52dbff58663a0b30d6ca.png)

I18n
-------------

Rails Email Preview expect emails to be rendered using `I18n.locale`:
    
    # current locale
    AccountMailer.some_notification.deliver     
    # different locale
    I18n.with_locale('es') { InviteMailer.send_invites.deliver }


If you are using `Resque::Mailer` or `Devise::Async`, you can automatically add I18n.locale information when the mail job is scheduled 
[with this initializer](https://gist.github.com/glebm/5725347).


Views
---------------------

You can change the layout for all Rails Email Preview views:

    Rails.application.config.to_prepare do
      RailsEmailPreview::ApplicationController.layout 'admin'
      # you can further extend RailsEmailPreview::ApplicationController here (to add admin authentatication etc)
    end

When using a layout other than the default, that layout has to access all the route helpers via `main_app`, e.g. `main_app.login_url`.
This is due to how [isolated engines](http://edgeapi.rubyonrails.org/classes/Rails/Engine.html#label-Isolated+Engine) work in Rails.

You can override any individual view by placing a file with the same path in your project's `app/views`, e.g. `app/views/rails_email_preview/emails/index.html.slim`.
You can also extend the `RailsEmailPreview::EmailsController` for further customization.


Authentication & authorization
------------------------------

To only allow certain users view emails add a before filter to `RailsEmailPreview::ApplicationController`, e.g.:

    Rails.application.config.to_prepare do
      RailsEmailPreview::ApplicationController.module_eval do
        before_filter :check_permissions
      
        private
        def check_permissions
           render status: 403 unless current_user.try(:admin?)
        end
      end
    end 


This project rocks and uses MIT-LICENSE.
