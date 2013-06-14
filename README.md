Rails Email Preview 
================================

A Rails Engine to preview plain text and html email in your browser. Compatible with Rails 3 and 4.

![screenshot](http://screencloud.net//img/screenshots/22aa58b651815068f4b0676754275c6a.png)
![screenshot](http://screencloud.net//img/screenshots/8861336ed60923429d3747e1fd379619.png)
*(styles are from the application)*

How to
-----

Add to Gemfile

    gem 'rails_email_preview'

Run generators

    # Add initializer and route
    rails g rails_email_preview:install

    # Generate preview classes and method stubs in app/mailer_previews/
    rails g rails_email_preview:update_previews

You will need to provide data for preview of each email:

    # Say there is a UserMailer with 2 actions
    # in app/mailer_previews/user_mailer_preview.rb initialize the emails for preview:
    class UserMailerPreview
      # preview methods should return Mail objects, e.g.:
      def invitation        
        UserMailer.invitation mock_user('Alice'), mock_user('Bob')
      end
            
      def welcome                
        UserMailer.welcome mock_user                            
      end
      
      private
      # You can put all your mock helpers in a module
      # Or, if you have factories/fabricators for your tests you could use those, but be careful not to create anything!
      def mock_user(name = 'Bill Gates')
        fake_id User.new(name: name, email: "user#{rand 100}@test.com")
      end

      def fake_id(obj)
        obj.define_singleton_method(:id) { 123 + rand(100) }
        obj
      end
    end


Routing
-------

You can access REP urls like this:

    rails_email_preview.root_url #=> '/emails'
    
Email editing 
-------------

You can use [comfortable_mexican_sofa](https://github.com/comfy/comfortable-mexican-sofa) for storing and editing emails.
REP comes with a CMS integration, see [ComfortableMexicanSofa integration guide](https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa).

![CMS integration screenshot](http://screencloud.net//img/screenshots/b000595dbd13ae061373fd1473f113ba.png)


Premailer integration
---------------------

[Premailer](https://github.com/alexdunae/premailer) automatically translates standard CSS rules into old-school inline styles. Integration can be done by using the <code>before_render</code> hook.

To integrate Premailer with your Rails app you can use either [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css) or [premailer-rails](https://github.com/fphilipe/premailer-rails).

For [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css), add to `RailsEmailPreview.setup`:
    
    config.before_render { |message| ActionMailer::InlineCssHook.delivering_email(message) }    

For [premailer-rails](https://github.com/fphilipe/premailer-rails), add to `RailsEmailPreview.setup`:
    
    config.before_render { |message| Premailer::Rails::Hook.delivering_email(message) }    


I18n
-------------

REP expects emails to use current `I18n.locale`:
    
    # current locale
    AccountMailer.some_notification.deliver     
    # different locale
    I18n.with_locale('es') { InviteMailer.send_invites.deliver }


If you are using `Resque::Mailer` or `Devise::Async`, you can automatically add I18n.locale information when the mail job is scheduled 
[with this initializer](https://gist.github.com/glebm/5725347).


Views
---------------------

You can render all REP views inside your own layout:

    Rails.application.config.to_prepare do
      RailsEmailPreview::ApplicationController.layout 'admin'      
    end

When using a layout other than the default, that layout has to access all route helpers via `main_app`, e.g. `main_app.login_url`.
This is due to how [isolated engines](http://edgeapi.rubyonrails.org/classes/Rails/Engine.html#label-Isolated+Engine) work in Rails.

You can also override any individual view by placing a file with the same path in your project's `app/views`, e.g. `app/views/rails_email_preview/emails/index.html.slim`.

*Pull requests adding view hooks are welcome!*


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
