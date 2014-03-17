class RailsEmailPreview::EmailsController < ::RailsEmailPreview::ApplicationController
  include ERB::Util
  before_filter :load_preview, except: :index
  around_filter :set_locale
  before_filter :set_email_preview_locale

  # list screen
  def index
    @previews = ::RailsEmailPreview::Preview.all
    @previews_by_class = ::RailsEmailPreview::Preview.all_by_preview_class
  end

  # preview screen
  def show
    I18n.with_locale @email_locale do
      @part_type = params[:part_type] || 'text/html'
      if @preview.respond_to?(:preview_mail)
        @mail = @preview.preview_mail
      else
        raise ArgumentError.new("#{@preview} is not a preview class, does not respond_to?(:preview_mail)")
      end
    end
  end

  # render actual email content
  def show_body
    I18n.with_locale @email_locale do
      @mail_body = mail_body(@preview, @part_type)
      render :show_body, layout: 'rails_email_preview/email'
    end
  end

  def test_deliver
    redirect_url = rails_email_preview.rep_email_url(params.slice(:preview_id, :email_locale))
    if (address = params[:recipient_email]).blank? || address !~ /@/
      redirect_to redirect_url, alert: t('rep.test_deliver.provide_email')
      return
    end
    I18n.with_locale @email_locale do
      delivery_handler = RailsEmailPreview::DeliveryHandler.new(@preview.preview_mail(true), to: address, cc: nil, bcc: nil)
      deliver_email!(delivery_handler.mail)
    end
    if !(delivery_method = Rails.application.config.action_mailer.delivery_method)
      redirect_to redirect_url, alert: t('rep.test_deliver.no_delivery_method', environment: Rails.env)
    else
      redirect_to redirect_url, notice: t('rep.test_deliver.sent_notice', address: address, delivery_method: delivery_method)
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

  def mail_body(preview, part_type, edit_links = (part_type == 'text/html'))
    RequestStore.store[:rep_edit_links] = true if edit_links
    mail = preview.preview_mail(true)

    return "<pre id='raw_message'>#{html_escape(mail.to_s)}</pre>".html_safe if part_type == 'raw'

    body_part = if mail.multipart?
                  (part_type =~ /html/ ? mail.html_part : mail.text_part)
                else
                  mail
                end
    if body_part.content_type =~ /plain/
      "<pre id='message_body'>#{html_escape(body_part.body.to_s)}</pre>".html_safe
    else
      body_part.body.to_s.html_safe
    end
  end

  def set_email_preview_locale
    @email_locale = (params[:email_locale] || RailsEmailPreview.default_email_locale || I18n.default_locale).to_s
  end

  def set_locale
    config_locale = RailsEmailPreview.locale
    if !I18n.available_locales.map(&:to_s).include?(config_locale.to_s)
      config_locale = :en
    end
    begin
      locale_was  = I18n.locale
      I18n.locale = config_locale
      yield if block_given?
    ensure
      I18n.locale = locale_was
    end
  end
  private

  def load_preview
    @preview     = ::RailsEmailPreview::Preview[params[:preview_id]] or raise ActionController::RoutingError.new('Not Found')
    @part_type   = params[:part_type] || 'text/html'
  end
end
