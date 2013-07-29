class RailsEmailPreview::EmailsController < ::RailsEmailPreview::ApplicationController
  include ERB::Util
  before_filter :load_preview_class, except: :index
  before_filter :set_email_preview_locale

  # list screen
  def index
    @preview_class_names = (RailsEmailPreview.preview_classes || []).map { |klass| klass.is_a?(String) ? klass : klass.name }.sort
  end

  # preview screen
  def show
    I18n.with_locale @email_locale do
      @part_type = params[:part_type] || 'text/html'
      if @preview_class.respond_to?(:new)
        @mail = preview_mail
      else
        raise ArgumentError.new("#{@preview_class} is not a preview class, does not respond_to?(:new)")
      end
    end
  end

  # render actual email content
  def show_raw
    I18n.with_locale @email_locale do
      @mail = preview_mail
      RailsEmailPreview.run_before_render(@mail, @preview_class.name, @mail_action)
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

  def test_deliver
    I18n.with_locale @email_locale do
      mail             = preview_mail
      address          = params[:recipient_email]
      delivery_handler = RailsEmailPreview::DeliveryHandler.new(mail, to: address, cc: nil, bcc: nil)
      deliver_email!(delivery_handler.mail)
      redirect_to rep_email_url(params.slice(:mail_class, :mail_action, :email_locale)), notice: "Sent to #{address}"
    end
  end

  protected

  def deliver_email!(mail)
    # support deliver! if present
    if mail.respond_to?(:deliver!)
      mail.deliver!
    else
      mail.deliver
    end
  end

  def preview_mail
    @preview_class.new.send(@mail_action)
  end

  def set_email_preview_locale
    @email_locale = (params[:email_locale] || I18n.default_locale).to_s
  end

  private

  def load_preview_class
    @preview_class = (RailsEmailPreview.preview_classes || []).find { |pc|
      (pc.is_a?(String) ? pc : pc.name).underscore == params[:mail_class]
    }
    @preview_class = @preview_class.constantize if @preview_class.is_a?(String)
    @mail_action = params[:mail_action]
    @part_type   = params[:part_type] || 'text/html'
  end
end
