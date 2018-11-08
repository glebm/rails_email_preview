# Rails Email Preview [![Build Status][travis-badge]][travis] [![Test Coverage][coverage-badge]][coverage] [![Code Climate][codeclimate-badge]][codeclimate] [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/glebm/rails_email_preview?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Preview email in the browser with this Rails engine. Compatible with Rails 4.2+.

An email review:

![screenshot][rep-show-screenshot]

The list of all email previews:

![screenshot][rep-nav-screenshot]

REP comes with two themes: a simple standalone theme, and a theme that uses [Bootstrap 3][rep-show-default-screenshot].

## Installation

Add [![Gem Version][gem-badge]][gem] to Gemfile:

```ruby
gem 'rails_email_preview', '~> 2.1.0'
```

Add an initializer and the routes:

```console
$ rails g rails_email_preview:install
```

Generate preview classes and method stubs in app/mailer_previews/

```console
$ rails g rails_email_preview:update_previews
```

## Usage

The last generator above will add a stub for each of your emails, then you populate the stubs with mock data:

```ruby
# app/mailer_previews/user_mailer_preview.rb:
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
  # or you can use your factories / fabricators, just make sure you are not creating anything
  def mock_user(name = 'Bill Gates')
    fake_id User.new(name: name, email: "user#{rand 100}@test.com")
  end

  def fake_id(obj)
    # overrides the method on just this object
    obj.define_singleton_method(:id) { 123 + rand(100) }
    obj
  end
end
```

### Parameters as instance variables

All parameters in the search query will be available to the preview class as instance variables.
For example, if URL to mailer preview looks like:

/emails/user_mailer_preview-welcome?**user_id=1**

The method `welcome` in `UserMailerPreview` have a `@user_id` instance variable defined:

```ruby
class UserMailerPreview
  def welcome
    user = @user_id ? User.find(@user_id) : mock_user
    UserMailer.welcome(user)
  end
end
```

Now you can preview or send the welcome email to a specific user.

### Routing

You can access REP urls like this:

```ruby
# engine root:
rails_email_preview.rep_root_url
# list of emails (same as root):
rails_email_preview.rep_emails_url
# email show:
rails_email_preview.rep_email_url('user_mailer-welcome')
```

### Sending Emails

You can send emails via REP. This is especially useful when testing with limited clients (Blackberry, Outlook, etc.).
This will use the environment's mailer settings, but the handler will `perform_deliveries`.
Uncomment this line in the initializer to disable sending test emails:

```ruby
config.enable_send_email = false
```

### Editing Emails

Emails can be stored in the database and edited in the browser.
REP works with [Comfortable Mexican Sofa CMS](https://github.com/comfy/comfortable-mexican-sofa) to achieve this -- see the [CMS Guide](https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa) to learn more.

[![screenshot](https://raw.github.com/glebm/rails_email_preview/master/doc/img/rep-edit-sofa.png)](https://github.com/glebm/rails_email_preview/wiki/Edit-Emails-with-Comfortable-Mexican-Sofa)

### CSS inlining

For CSS inlining, REP supports [Roadie](https://github.com/Mange/roadie) and
[Premailer](https://github.com/alexdunae/premailer).
Both of these automatically translate CSS rules into inline styles and turn
relative URLs into absolute ones.

Roadie additionally extracts styles that cannot be inlined into a separate
`<style>` tag that is supported by some email clients. For this reason I
recommend Roadie over Premailer.

Unlike Premailer, Roadie does **not** automatically generate a plain text
version for HTML emails, but you can use another gem for this, such as
[plain-david](https://github.com/lucaspiller/plain-david).

#### Roadie

To integrate Roadie with your Rails app, use [roadie-rails](https://github.com/Mange/roadie-rails).
To integrate roadie-rails with REP, uncomment the relevant option in [the initializer](https://github.com/glebm/rails_email_preview/blob/master/config/initializers/rails_email_preview.rb). *initializer is generated during `rails g rails_email_preview:install`*

#### Premailer

To integrate Premailer with your Rails app you can use either [actionmailer_inline_css](https://github.com/ndbroadbent/actionmailer_inline_css) or [premailer-rails](https://github.com/fphilipe/premailer-rails).
To integrate either with REP, uncomment the relevant options in [the initializer](https://github.com/glebm/rails_email_preview/blob/master/config/initializers/rails_email_preview.rb). *initializer is generated during `rails g rails_email_preview:install`*

### I18n

REP expects emails to use current `I18n.locale`:

```ruby
# current locale
AccountMailer.some_notification.deliver
# different locale
I18n.with_locale('es') do
  InviteMailer.send_invites.deliver
end
```

If you are using `Resque::Mailer` or `Devise::Async`, you can automatically remember `I18n.locale` when the mail job is scheduled
[with this initializer](https://gist.github.com/glebm/5725347).

When linking to REP pages you can pass `email_locale` to set the locale for rendering:

```ruby
# will render email in Spanish:
rails_email_preview.root_url(email_locale: 'es')
```

REP displays too many locales? Make sure to set `config.i18n.available_locales`, since it defaults to *all* locales in Rails.

User interface is available in English, German (Danke, @baschtl), and Russian.
You can set the language in `config.to_prepare` section of the initializer, default is English.

```ruby
# config/initializers/rails_email_preview.rb
RailsEmailPreview.locale = :de
```

### Views

By default REP views will render inside its own layout.

To render all REP views inside your app layout, first set the layout to use in the initializer:

```ruby
Rails.application.config.to_prepare do
  # Use admin layout with REP (this will also make app routes accessible within REP):
  RailsEmailPreview.layout = 'admin'
end
```

Then, import REP styles into your `application.css.scss`:

```scss
@import "rails_email_preview/application";
```

Alternatively, if you are using Bootstrap 3, `@import "rails_email_preview/bootstrap3"`, and add the following
to the initializer:

```ruby
config.style.merge!(
    btn_active_class_modifier: 'active',
    btn_danger_class:          'btn btn-danger',
    btn_default_class:         'btn btn-default',
    btn_group_class:           'btn-group btn-group-sm',
    btn_primary_class:         'btn btn-primary',
    form_control_class:        'form-control',
    list_group_class:          'list-group',
    list_group_item_class:     'list-group-item',
    row_class:                 'row',
)
```

You can also override any individual view by placing a file with the same path in your project's `app/views`,
e.g. `app/views/rails_email_preview/emails/index.html.slim`.

#### Hooks

You can add content around or replacing REP UI elements by registering view hooks in the initializer:

```ruby
# Pass position (before, after, or replace) and render arguments:
RailsEmailPreview.view_hooks.add_render :list, :before, partial: 'shared/hello'

# Pass hook id and position (before, after, or replace):
RailsEmailPreview.view_hooks.add :headers_content, :after do |mail:, preview:|
  raw "<dt>ID</dt><dd>#{h mail.header['X-APP-EMAIL-ID']}</dd>"
end
```

All of the available hooks can be found [here](/lib/rails_email_preview/view_hooks.rb#L10).

### Authentication & authorization

You can specify the parent controller for REP controller, and it will inherit all the before filters.
Note that this must be placed before any other references to REP application controller in the initializer (and before `layout=` call):

```ruby
RailsEmailPreview.parent_controller = 'Admin::ApplicationController' # default: '::ApplicationController'
```

Alternatively, to have custom rules just for REP you can:

```ruby
Rails.application.config.to_prepare do
  RailsEmailPreview::ApplicationController.module_eval do
    before_action :check_rep_permissions

    private
    def check_rep_permissions
       render status: 403 unless current_user && can_manage_emails?(current_user)
    end
  end
end
```

## Development

Run the tests:

```console
$ rspec
```

Start a development web server on [localhost:9292](http://localhost:9292):

```console
$ rake dev
```

This project rocks and uses MIT-LICENSE.

[rep-nav-screenshot]: https://raw.github.com/glebm/rails_email_preview/master/doc/img/rep-nav.png "Email List Screenshot"
[rep-show-screenshot]: https://raw.github.com/glebm/rails_email_preview/master/doc/img/rep-show.png "Show Email Screenshot"
[rep-show-default-screenshot]: https://raw.github.com/glebm/rails_email_preview/master/doc/img/rep-show-default.png "Show Email Screenshot (default styles)"
[travis]: http://travis-ci.org/glebm/rails_email_preview
[travis-badge]: http://img.shields.io/travis/glebm/rails_email_preview.svg
[gem]: https://rubygems.org/gems/rails_email_preview
[gem-badge]: http://img.shields.io/gem/v/rails_email_preview.svg
[codeclimate]: https://codeclimate.com/github/glebm/rails_email_preview
[codeclimate-badge]: http://img.shields.io/codeclimate/github/glebm/rails_email_preview.svg
[coverage]: https://codeclimate.com/github/glebm/rails_email_preview
[coverage-badge]: https://codeclimate.com/github/glebm/rails_email_preview/badges/coverage.svg
