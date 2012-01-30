RailsEmailPreview -- Visual email testing
================================

Preview plain text and html mail templates in your browser without redelivering it every time you make a change.

Inspired by MailView: https://github.com/37signals/mail_view/
However, implemented as a Rails engine, with layouts and multiple mailers support.

Compatible with Rails version >= 3 only.

Usage
-----

Since most emails do something interesting with database data, you'll need to write some scenarios to load messages with fake data. Its similar to writing mailer unit tests but you see a visual representation of the output instead.

    class Notifier < ActionMailer::Base
      def invitation(inviter, invitee)
        # ...
      end

      def welcome(user)
        # ...
      end

      class Preview
        # Pull data from existing fixtures
        def invitation
          account = Account.first
          inviter, invitee = account.users[0, 2]
          Notifier.invitation(inviter, invitee)
        end

        # Factory-like pattern
        def welcome
          user = User.create!
          mail = Notifier.welcome(user)
          user.destory
          mail
        end
      end
    end

The methods must return a Mail object.

Since this is a Rails engine, it can be configured in an initializer:

In config/initializers/rails_email_preview.rb

    require 'rails_email_preview'
    RailsEmailPreview.setup do |config|
      config.preview_classes = [ Notifier::Preview ]
    end

    # If you want to render it within the application layout, uncomment the following lines:
    # Rails.application.config.to_prepare do
    #   RailsEmailPreview::ApplicationController.layout "application"
    # end
    # Note that if you do use it with your main_app layout, all the main_app URLs must be generated explicitly
    # E.g. you would need to change links like login_url to main_app.login_url


Routing is very simple

In config/routes.rb add:

    if Rails.env.development?
      mount RailsEmailPreview::Engine, :at => 'email_preview' # You can choose any URL here
    end

To get the url of RailsEmailPreview in your main app you can call rails_email_preview.root_url

Interface
---------

ToDo: Add a screenshot

This project rocks and uses MIT-LICENSE.