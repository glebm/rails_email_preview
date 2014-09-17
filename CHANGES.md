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
