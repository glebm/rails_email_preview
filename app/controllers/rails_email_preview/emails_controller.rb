class RailsEmailPreview::EmailsController < ::RailsEmailPreview::ApplicationController
  include ERB::Util
  before_filter :load_preview_class, except: :index
  before_filter :set_email_preview_locale

  # list screen
  def index
    @preview_class_names = (RailsEmailPreview.preview_classes || []).map { |klass| klass.is_a?(String) ? klass : klass.name }
  end

  # preview screen
  def show
    I18n.with_locale @email_locale do
      @part_type = params[:part_type] || 'text/html'
      if @preview_class.respond_to?(:new)
        @mail = @preview_class.new.send(params[:mail_action])
      else
        # @preview_class is not a preview class
        arg_info = "#{@preview_class}"
        if @preview_class.is_a?(Module)
          chain = @preview_class.ancestors.map(&:to_s)
          chain = chain[1 .. chain.index { |c| c =~ /^Application[A-Z][A-z]+$/ } || -1]
        end
        raise ArgumentError.new("#{arg_info} is not a preview class #{"(ancestors: #{chain * ' < '})"} ")
      end
    end
    render
  end

  # render actual email content
  def show_raw
    I18n.with_locale @email_locale do
      @mail = @preview_class.new.send(params[:mail_action])
      RailsEmailPreview.run_before_render(@mail)
      if @part_type == 'raw'
        body = "<pre id='raw_message'>#{html_escape(@mail.to_s)}</pre>"
      else
        if @mail.multipart?
          body_part = (@part_type =~ /html/ ? @mail.html_part : @mail.text_part)
        else
          body_part = @mail
        end
        body = body_part.body
        if body_part.content_type =~ /plain/
          body = "<pre id='message_body'>#{body}</body>"
        end
      end
      render text: body, layout: false
    end
  end

  protected

  def set_email_preview_locale
    @email_locale = (params[:email_locale] || I18n.default_locale).to_s
  end

  private

  def load_preview_class
    @preview_class = (RailsEmailPreview.preview_classes || []).find { |pc|
      (pc.is_a?(String) ? pc : pc.name).underscore == params[:mail_class]
    }
    @preview_class = @preview_class.constantize if @preview_class.is_a?(String)
    @part_type = params[:part_type] || 'text/html'
  end
end
