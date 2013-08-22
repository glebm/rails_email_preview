require File.expand_path('../lib/rails_email_preview/version', __FILE__)


Gem::Specification.new do |s|
  s.name = 'rails_email_preview'
  s.author = 'Gleb Mazovetskiy'
  s.email = 'glex.spb@gmail.com'
  s.homepage = 'https://github.com/glebm/rails_email_preview'
  s.license = 'MIT'

  s.summary = 'Preview emails in browser (rails engine)'
  s.description = 'Implemented as a rails engine with a simple UI for previewing your app emails,
I18n support, easy premailer integration and editing integration via comfortable_mexican_sofa CMS.'


  s.files = Dir['{app,lib,config}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.md']

  s.add_dependency 'activesupport', '>= 3.2'
  s.add_dependency 'rails', '>= 3.2'
  s.add_dependency 'slim'
  s.add_dependency 'slim-rails'
  s.add_dependency 'sass'
  s.add_dependency 'sass-rails'
  s.add_dependency 'thor'
  s.add_dependency 'turbolinks'
  s.add_dependency 'request_store'

  s.version = RailsEmailPreview::VERSION
end
