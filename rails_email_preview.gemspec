require File.expand_path("../lib/rails_email_preview/version", __FILE__)


Gem::Specification.new do |s|
  s.name = "rails_email_preview"
  s.author = 'Gleb Mazovetskiy'
  s.email = 'glex.spb@gmail.com'
  s.description = s.summary = "Preview emails in browser (rails engine)" 

  s.files = Dir["{app,lib,config}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "README.md"]

  s.add_dependency "activesupport", ">= 3.2"
  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "slim"
  s.add_dependency "sass"

  s.version = RailsEmailPreview::VERSION
end
