module RailsEmailPreview
  module Generators
    class UpdatePreviewsGenerator < Rails::Generators::Base
      desc "creates app/mailer_previews/NEW_MAILER_preview.rb for each new mailer"
      def generate_mailer_previews
        previews_dir = 'app/mailer_previews/'
        empty_directory previews_dir
        Dir['app/mailers/*.rb'].each do |p|
          basename = File.basename(p, '.rb')
          if basename == 'application_mailer' || File.read(p) !~ /\bdef\s/
            shell.say_status :skip, basename, :blue
            next
          end
          preview_path = File.join(previews_dir, "#{basename}_preview.rb")
          if File.exists?(preview_path)
            shell.say_status :exist, preview_path, :blue
            next
          end
          create_file preview_path, mailer_class_body(basename.camelize)
        end
      end

      private

      def mailer_class_body(mailer_class_name)
<<-RUBY
class #{mailer_class_name}Preview
#{(mailer_methods(mailer_class_name) * "\n\n").chomp}
end
RUBY
      end

      def mailer_methods(mailer_class_name)
        mailer_class = mailer_class_name.constantize
        ::RailsEmailPreview::Preview.mail_methods(mailer_class).map do |m|
<<-RUBY
  def #{m}
    #{mailer_class_name}.#{m.to_s} #{mailer_class.instance_method(m).parameters.map(&:second) * ', '}
  end
RUBY
        end
      end

    end
  end
end
