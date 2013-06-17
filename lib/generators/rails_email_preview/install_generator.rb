module RailsEmailPreview
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "creates an initializer file at config/initializers/rails_email_preview.rb and adds REP route to config/routes.rb"
      source_root File.expand_path('../../../..', __FILE__)

      def generate_initialization
        copy_file 'config/initializers/rails_email_preview.rb', 'config/initializers/rails_email_preview.rb'
      end

      def generate_routing
        route "mount RailsEmailPreview::Engine, at: 'emails'"
        log "# You can access REP urls like this: rails_email_preview.rep_emails_url #=> '/emails'"
      end
    end
  end
end
