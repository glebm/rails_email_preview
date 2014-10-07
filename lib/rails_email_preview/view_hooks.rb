module RailsEmailPreview
  # Add hooks before, after, or replacing a UI element
  class ViewHooks
    args      = {
        index: [:list, :previews].freeze,
        show:  [:mail, :preview].freeze
    }
    # All valid hooks and their argument names
    SCHEMA    = {
        list:            args[:index],
        breadcrumb:      args[:show],
        breadcrumb_content: args[:show],
        headers_and_nav: args[:show],
        headers:         args[:show],
        headers_content: args[:show],
        nav:             args[:show],
        nav_i18n:        args[:show],
        nav_format:      args[:show],
        nav_send:        args[:show],
        email_body:      args[:show],
    }
    POSITIONS = [:before, :replace, :after].freeze

    def initialize
      @hooks = Hooks.new
    end

    # @param [Symbol] id
    # @param [:before, :replace, :after] pos
    # @example
    #   view_hooks.add_render :list, :before, partial: 'shared/hello'
    def add_render(id, pos, *render_args)
      render_args = render_args.dup
      render_opts = render_args.extract_options!.dup
      add id, pos do |locals = {}|
        render *render_args, render_opts.merge(
            locals: (render_opts[:locals] || {}).merge(locals))
      end
    end

    # @param [Symbol] id
    # @param [:before, :replace, :after] pos
    # @example
    #   view_hooks.add :headers_content, :after do |mail:, preview:|
    #     raw "<b>ID</b>: #{h mail.header['X-APP-EMAIL-ID']}"
    #   end
    def add(id, pos, &block)
      @hooks[id][pos] << block
    end

    def render(hook_id, locals, template, &content)
      at = @hooks[hook_id]
      validate_locals! hook_id, locals
      parts = [
          render_providers(at[:before], locals, template),
          if at[:replace].present?
            render_providers(at[:replace], locals, template)
          else
            template.capture { content.call(locals) }
          end,
          render_providers(at[:after], locals, template)
      ]
      template.safe_join(parts, '')
    end

    private

    def render_providers(providers, locals, template)
      template.safe_join providers.map { |provider| template.instance_exec(locals, &provider) }, ''
    end

    def validate_locals!(hook_id, locals)
      if locals.keys.sort != SCHEMA[hook_id].sort
        raise ArgumentError.new("Invalid arguments #{locals.keys}. Valid: #{SCHEMA[hook_id]}")
      end
    end

    class Hooks < DelegateClass(Hash)
      def initialize
        super Hash.new { |h, id|
          validate_id! id
          h[id] = Hash.new { |hh, pos|
            validate_pos! pos
            hh[pos] = []
          }
        }
      end

      private

      def validate_id!(id)
        raise ArgumentError.new('hook id must be a symbol') unless Symbol === id
        raise ArgumentError.new("Invalid hook #{id}. Valid: #{SCHEMA.keys * ', '}.") unless SCHEMA.key?(id)
      end

      def validate_pos!(pos)
        raise ArgumentError.new("Invalid position #{pos}. Valid: #{POSITIONS * ', '}") unless POSITIONS.include?(pos)
      end
    end
  end
end
