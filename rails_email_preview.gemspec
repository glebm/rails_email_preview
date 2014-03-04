require File.expand_path('../lib/rails_email_preview/version', __FILE__)


Gem::Specification.new do |s|
  s.name = 'rails_email_preview'
  s.author = 'Gleb Mazovetskiy'
  s.email = 'glex.spb@gmail.com'
  s.homepage = 'https://github.com/glebm/rails_email_preview'
  s.license = 'MIT'

  s.summary = 'Preview emails in browser (rails engine)'
  s.description = 'A Rails Engine to preview plain text and html email in your browser. Compatible with Rails 3 and 4.'


  s.files = Dir['{app,lib,config}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.md']

  s.add_dependency 'rails', '>= 3.2'
  s.add_dependency 'slim-rails'
  s.add_dependency 'sass-rails'
  s.add_dependency 'turbolinks'
  s.add_dependency 'request_store'

  s.add_development_dependency 'i18n-tasks', '>= 0.3.7'
  s.add_development_dependency 'capybara', '>= 0.4.0'
  s.add_development_dependency 'rspec', '>= 2.12.0'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'poltergeist'

  s.version = RailsEmailPreview::VERSION
end
