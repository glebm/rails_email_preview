module RailsEmailPreview
  # This class represents an email preview
  class Preview
    attr_accessor :id, :preview_class_name, :preview_method

    def initialize(attr = {})
      attr.each { |k, v| self.send "#{k}=", v }
    end

    def preview_mail
      preview_class_name.constantize.new.send(preview_method)
    end

    def name
      @name ||= "#{group_name}: #{method_name}"
    end

    def method_name
      @action_name ||= preview_method.to_s.humanize
    end

    def group_name
      @group_name ||= preview_class_name.to_s.underscore.sub(/(_mailer)?_preview$/, '').humanize
    end

    class << self
      def find(email_id)
        @by_id[email_id]
      end

      alias_method :[], :find

      attr_reader :all, :all_by_preview_class

      def mail_methods(mailer)
        mailer.public_instance_methods(false).map(&:to_s)
      end

      def load_all(class_names)
        @all   = []
        @by_id = {}
        class_names.each do |preview_class_name|
          preview_class     = preview_class_name.constantize

          mail_methods(preview_class).sort.each do |preview_method|
            mailer_method = preview_method
            id            = "#{preview_class_name.underscore}-#{mailer_method}"

            email = new(
                id:                 id,
                preview_class_name: preview_class_name,
                preview_method:     preview_method
            )
            @all << email
            @by_id[id] = email
          end
        end
        @all.sort_by!(&:name)
        @all_by_preview_class = @all.group_by(&:preview_class_name)
      end
    end
  end
end
