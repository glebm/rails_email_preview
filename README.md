Rails Email Preview 
================================

A Rails Engine to preview plain text and html email in your browser. Compatible with Rails 3 and 4.

Usage
-----

Since most emails use data, you will need to provide it to the preview.

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


Configuration
---

In config/initializers/rails_email_preview.rb

    require 'rails_email_preview'
    RailsEmailPreview.setup do |config|
      config.preview_classes = [ Notifier::Preview ]
    end

    # If you want to render preview views within the application layout, uncomment the following lines:
    # Rails.application.config.to_prepare do
    #   RailsEmailPreview::ApplicationController.layout "application"
    # end
    # Note that if you use it with an app layout, all the app URLs in the layout file must be generated explicitly via `main_app`
    # E.g. `login_url` would need to be changed to `main_app.login_url` (this is due to how isolated engines are implemented in Rails).


Routing is very simple

In `config/routes.rb` add:

    if Rails.env.development?
      mount RailsEmailPreview::Engine, at: 'email_preview' # You can choose any URL here
    end

To get the url of RailsEmailPreview in your app use `rails_email_preview.root_url`


Premailer integration
---------------------

[Premailer](https://github.com/alexdunae/premailer) automatically translates standard CSS rules into old-school inline styles. Integration can be done by using the <code>before_render</code> hook:

    RailsEmailPreview.setup do |config|
      config.before_render do |message|
        ActionMailer::InlineCssHook.delivering_email(message)
      end
    end

If you're your running Rails 3, you may consider using [premailer-rails](https://github.com/fphilipe/premailer-rails). It will inline CSS, automatically create plain text emails, and requires almost no configuration.


    RailsEmailPreview.setup do |config|
      config.before_render do |message|
        Premailer::Rails::Hook.delivering_email(message)
      end
    end

You can ovveride any view by placing a file with the same path in `app/views`.


---
This project rocks and uses MIT-LICENSE.
