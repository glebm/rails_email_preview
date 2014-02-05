require File.expand_path('../lib/rails_email_preview/version', __FILE__)


Gem::Specification.new do |s|
  s.name = 'rails_email_preview'
  s.author = 'Gleb Mazovetskiy'
  s.email = 'glex.spb@gmail.com'
  s.homepage = 'https://github.com/glebm/rails_email_preview'
  s.license = 'MIT'

  s.summary = 'Preview emails in browser (rails engine)'
  s.description = 'Rails engine to preview, test send, and edit application email in browser. i18n support, premailer integration, and more.'


  s.files = Dir['{app,lib,config}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.md']

  s.add_dependency 'rails', '>= 3.2'
  s.add_dependency 'slim-rails'
  s.add_dependency 'sass-rails'
  # Locking turbolinks on 1.3.1 since 2.2.1 breaks our code. Needs an update once
  # the following commit is merged into turbolinks: https://github.com/rails/turbolinks/commit/174ef17a75bfc0a5e83f4d71966e8306c37991d8
  s.add_dependency 'turbolinks', '1.3.1'
  s.add_dependency 'request_store'

  s.version = RailsEmailPreview::VERSION
end
