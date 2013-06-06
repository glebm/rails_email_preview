Rails Email Preview 
================================

A Rails Engine to preview plain text and html email in your browser. Compatible with Rails 3 and 4.

![screenshot](http://screencloud.net//img/screenshots/749d6c6a84b5d79b436ad627902944a8.png)
*Preview UI (editing and i18n are custom and are not part of this gem)*

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

    # To render previews within layout other than the default one. NB: that layout must reference application urls via `main_app`, e.g. `main_app.login_url` (due to how isolated engines are in rails):

    Rails.application.config.to_prepare do
      RailsEmailPreview::ApplicationController.layout 'admin'
    end


Premailer integration
---------------------

[Premailer](https://github.com/alexdunae/premailer) automatically translates standard CSS rules into old-school inline styles. Integration can be done by using the <code>before_render</code> hook.

To integrate Premailer with rails you can use either [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css) or [premailer-rails](https://github.com/fphilipe/premailer-rails).

For [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css), add to `RailsEmailPreview.setup`:
    
    config.before_render { |message| ActionMailer::InlineCssHook.delivering_email(message) }    

For [premailer-rails](https://github.com/fphilipe/premailer-rails), add to `RailsEmailPreview.setup`:
    
    config.before_render { |message| Premailer::Rails::Hook.delivering_email(message) }    


Customizing views
---------------------

You can ovveride any `rails_email_preview` view by placing a file with the same path as in the gem in your project's `app/views`.

Interface
---------

![List of application mails](http://4.bp.blogspot.com/-hkZlhO7ze8I/Tylinqxas2I/AAAAAAAABQo/17eEkwBkdnQ/s1600/email-preview-index.png)

You can override any `rails_email_preview` view by placing a file with the same path as in the gem in your project's `app/views`.
You can also extend the `RailsEmailPreview::EmailsController` for further customization.

This project rocks and uses MIT-LICENSE.
