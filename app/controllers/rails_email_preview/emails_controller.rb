class RailsEmailPreview::EmailsController < RailsEmailPreview::ApplicationController
  include ERB::Util
  before_filter :load_preview_class, except: :index
  before_filter :set_locale, except: :index

  def index
    @preview_class_names = (RailsEmailPreview.preview_classes || []).map { |klass| klass.is_a?(String) ? klass : klass.name }
  end

  def show
    @mail = @preview_class.new.send(params[:mail_action])
  end

  def show_raw
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

    render :text => body, :layout => false
  end

  private

  def set_locale
    I18n.locale = params[:locale]
  end

  def load_preview_class
    @preview_class = (RailsEmailPreview.preview_classes || []).find { |pc|
      (pc.is_a?(String) ? pc : pc.name).underscore == params[:mail_class]
    }
    @preview_class = @preview_class.constantize if @preview_class.is_a?(String)
    @part_type = params[:part_type] || 'text/html'
  end
end
