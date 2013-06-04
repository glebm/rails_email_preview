require File.expand_path("../lib/rails_email_preview/version", __FILE__)


Gem::Specification.new do |s|
  s.name = "rails_email_preview"
  s.author = 'Gleb Mazovetskiy'
  s.email = 'glex.spb@gmail.com'
  s.summary = "Visual Email Preview for Rails >= 3, implemented as a Rails Engine. v#{RailsEmailPreview::VERSION}"
  s.description = "Insert RailsEmailPreview description."

  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]

  s.add_dependency "activesupport", ">= 3.2"
  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "haml"
  s.add_dependency "sass"

  s.version = RailsEmailPreview::VERSION
end
