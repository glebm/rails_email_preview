Rails Email Preview 
================================

A Rails Engine to preview plain text and html email in your browser. Compatible with Rails 3 and 4.

How to
-----

You will need to provide data for preview of each email:

    # Say you have this mailer
    class Notifier < ActionMailer::Base
      def invitation(inviter, invitee)
        # ...
      end

      def welcome(user)
        # ...
      end

      # Define a Preview class with the same mail action names, but with no arguments
      class Preview
        # The only requirement is that you return a Mail object from the preview methods
        # You could use existing data for this:
        def invitation
          account = Account.first
          inviter, invitee = account.users[0, 2]
          Notifier.invitation(inviter, invitee)
        end

        # In most cases though it's better to build the data the email requires:
        def welcome
          User.transaction do 
            user = User.new(email: "user@test.com", name: "Test User")
            user.define_singleton_method(:id) { 123 }
            Notifier.welcome(user)                    
          end
        end
      end
    end


Routing
-------
    
    mount RailsEmailPreview::Engine, at: 'email_preview' # rails_email_preview.root_url #=> '/email_preview'    


Config 
-------
    
    # config/initializers/rails_email_preview.rb

    require 'rails_email_preview'
    RailsEmailPreview.setup do |config|
      config.preview_classes = [ Notifier::Preview ]
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

For [premailer-rails](https://github.com/fphilipe/premailer-rails):
    
    config.before_render { |message| Premailer::Rails::Hook.delivering_email(message) }    


Customizing rails_email_preview views
---------------------

You can ovveride any `rails_email_preview` view by placing a file with the same path as in the gem in your project's `app/views`.


This project rocks and uses MIT-LICENSE.
