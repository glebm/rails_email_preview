## v2.1.0

Use `sassc-rails` instead of `sass-rails`.

## v2.0.6

CMS integration now supports Comfy v2.

## v2.0.4

Depend on `sass` instead of `sass-rails`.

## v2.0.3

Fix a URL generation issue in the CMS integration on Rails 5.

## v2.0.2

* Document roadie-rails support.
* Fix body iframe height calculation.

## v2.0.1

Drop support for all versions of Rails below 4.2.
Fix Rails 5 deprecation warnings.

## v1.0.3

Rails 5 support.

## v1.0.2

Added a couple of variables for further default theme customization.

## v1.0.1

Added `RailsEmailPreview.find_preview_classes(dir)` that also finds classes in subdirectories, and changed the default
initializer to load classes like this:

```ruby
RailsEmailPreview.preview_classes = RailsEmailPreview.find_preview_classes('app/mailer_previews')
```

## v1.0.0

**Breaking**: REP now uses a lightweight default theme with no dependencies by default.

If you are using REP with the Bootstrap 3 theme, here are the configuration changes you need to make:

* `@import "rails_email_preview/bootstrap3"` instead of `rails_email_preview/application`.
* Add the following styles configuration to your REP initializer:
  
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

The following REP internal class names have changed:

* `.rep-email-options` is now `.rep--email-options`.
* `.rep-headers-list` is now `.rep--headers-list`.
* `.rep-email-show` is now `.rep--email-show`.
* `.breadcrumb` is now `.rep--breadcrumbs`.
* `.breadcrumb .active` is now `.rep--breadcrumbs__active`.
* `.rep-send-to-wrapper` is gone, but now there is `.rep--send-to-form`.

All REP views are now wrapped in a `div` with the `rep--main-container` class. 

REP no longer depends on slim and slim-rails.

Fixed minor email locale handling bugs in navigation and the CMS integration.

## v0.2.31

* Compatibility with namespaced email classes in the CMS.

## v0.2.30

* Compatibility with namespaced email classes.
* Change Sass stylesheets extensions from `.sass` to `.css.sass`. [#61](https://github.com/glebm/rails_email_preview/issues/61).
* Spanish translation. Thanks, @epergo!

## v0.2.29

* Latest CMS compatibility
* Rails 4.2: avoid deprecation warnings

## v0.2.28

* CMS beta compatibility

## v0.2.27

* Improve CMS compatibility
* New hook: breadcrumb

## v0.2.26

* Fix an issue with preview list [#47](https://github.com/glebm/rails_email_preview/issues/47).
* Fix a number of minor issues.

## v0.2.25

* Show attachment headers in the link's hover text (HTML title).
* Faster loading via `DOMContentLoaded` on the iframe as opposed to `load`.

## v0.2.24

* Fix regression: Rails 3 support.

## v0.2.23

* **View hooks** to inject or replace UI selectively.
* Fix regression in attachments caused by having a controller action named `headers` (name conflict).

## v0.2.22

* **Preview params** set from URL query. Thank you, @OlgaGr!
* Routes now include locale and part type as segments (with defaults).
* Faster loading using **srcdoc** iframe attribute; new progress bar.
* New language: Russian.
* Minor bugfixes.

## v0.2.21

* **Attachments**. Thanks, @rzane!
* CMS: 1.12 compatibility, better error messages.

## v0.2.20

* REP will fall back to :en if its set locale is not in the list of available locales

## v0.2.19

* Fixes for CMS integration

## v0.2.18

* UI language is now set to :en by default, to avoid #32
* Rails 3 compatibility issues fixed

## v0.2.17

* Fix preview generator

## v0.2.15 .. v0.2.16

* minor bugfixes
* UI improvements

## v0.2.13 .. v0.2.14

* clean up dependencies
* squell compatibility

## v0.2.11 .. v0.2.12

* german translation thanks to @baschtl
* email iframe resizes on window resize
* bugfixes

## v0.2.10

* simplified setting custom layout with `layout=`
* bugfixes

## v0.2.9

* updated bootstrap, turbolinks
* internal: tests + screenshots in spec/screenshots/ after each test run

## v0.2.8

bugs fixed, looks improved

## v0.2.7

* config.style to customize classes in REP views

## v0.2.4 .. 0.2.6

* UI enhancements
* CMS integration bug fixes
* Send email bug fixes

## v0.2.3

* Send Email from REP

## v0.2.0

* inline_main_app_routes! (enables easy layout switching)
* parent_controller (enables easy authorization integration)
* Backwards incompatible: root_url is now rep_root_url, internal routes are prefixed too.
