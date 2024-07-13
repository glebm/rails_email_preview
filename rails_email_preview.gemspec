require File.expand_path('../lib/rails_email_preview/version', __FILE__)


Gem::Specification.new do |s|
  s.name = 'rails_email_preview'
  s.author = 'Gleb Mazovetskiy'
  s.email = 'glex.spb@gmail.com'
  s.homepage = 'https://github.com/glebm/rails_email_preview'
  s.license = 'MIT'

  s.summary = 'Preview emails in browser (rails engine)'
  s.description = 'A Rails Engine to preview plain text and html email in your browser'

  s.files = Dir['{app,lib,config}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'Gemfile', 'README.md']

  if s.respond_to?(:metadata=)
    s.metadata = { 'issue_tracker' => 'https://github.com/glebm/rails_email_preview' }
  end

  s.add_dependency 'rails', '>= 4.2'
  s.add_dependency 'turbolinks'
  s.add_dependency 'request_store'

  s.add_development_dependency 'capybara', '>= 3.1.1'
  s.add_development_dependency 'cuprite', '>= 0.10'
  s.add_development_dependency 'rspec-rails', '>= 3.8.0'
  s.add_development_dependency 'puma', '>= 3.9.1'

  s.version = RailsEmailPreview::VERSION
end
