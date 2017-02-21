module RailsEmailPreview
  # Preview for one mailer method
  class Preview
    attr_accessor :id, :preview_class_name, :preview_method

    def initialize(attr = {})
      attr.each { |k, v| self.send "#{k}=", v }
    end

    def locales
      I18n.available_locales
    end

    def formats
      %w(html plain raw)
    end

    def preview_mail(run_hooks = false, search_query_params = {})
      preview_instance = preview_class_name.constantize.new
      setup_instance_variables(preview_instance, search_query_params)

      preview_instance.send(preview_method).tap do |mail|
        RailsEmailPreview.run_before_render(mail, self) if run_hooks
      end
    end

    def name
      @name ||= "#{group_name}: #{humanized_method_name}"
    end

    def humanized_method_name
      @action_name ||= preview_method.to_s.humanize
    end

    # @deprecated {#method_name} is deprecated and will be removed in v3
    alias_method :method_name, :humanized_method_name

    def group_name
      @group_name ||= preview_class_name.to_s.underscore.gsub('/', ': ').sub(/(_mailer)?_preview$/, '').humanize
    end

    class << self
      def find(email_id)
        @by_id[email_id]
      end

      alias_method :[], :find

      attr_reader :all

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
            id            = "#{preview_class_name.underscore.gsub('/', '__')}-#{mailer_method}"

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
      end
    end

    private

    def setup_instance_variables(object, params)
      unless params.empty?
        params.each { |k,v| object.instance_variable_set("@#{k}", v) }
      end
    end
  end
end
