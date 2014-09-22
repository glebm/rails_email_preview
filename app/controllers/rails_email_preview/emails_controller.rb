module RailsEmailPreview
  class EmailsController < ::RailsEmailPreview::ApplicationController
    include ERB::Util
    before_filter :load_preview, except: :index
    around_filter :set_locale
    before_filter :set_email_preview_locale
    helper_method :with_email_locale

    # List of emails
    def index
      @previews = Preview.all
      @list     = PreviewListPresenter.new(@previews)
    end

    # Preview an email
    def show
      prevent_browser_caching
      cms_edit_links!
      with_email_locale do
        if @preview.respond_to?(:preview_mail)
          @mail, body     = mail_and_body
          @mail_body_html = render_to_string inline: body, layout: 'rails_email_preview/email'
        else
          raise ArgumentError.new("#{@preview} is not a preview class, does not respond_to?(:preview_mail)")
        end
      end
    end

    # Really deliver an email
    def test_deliver
      redirect_url = rails_email_preview.rep_email_url(params.slice(:preview_id, :email_locale))
      if (address = params[:recipient_email]).blank? || address !~ /@/
        redirect_to redirect_url, alert: t('rep.test_deliver.provide_email')
        return
      end
      with_email_locale do
        delivery_handler = RailsEmailPreview::DeliveryHandler.new(preview_mail, to: address, cc: nil, bcc: nil)
        deliver_email!(delivery_handler.mail)
      end
      delivery_method = Rails.application.config.action_mailer.delivery_method
      if delivery_method
        redirect_to redirect_url, notice: t('rep.test_deliver.sent_notice', address: address, delivery_method: delivery_method)
      else
        redirect_to redirect_url, alert: t('rep.test_deliver.no_delivery_method', environment: Rails.env)
      end
    end

    # Download attachment
    def show_attachment
      filename   = "#{params[:filename]}.#{params[:format]}"
      attachment = preview_mail(false).attachments.find { |a| a.filename == filename }
      send_data attachment.body.raw_source, filename: filename
    end

    # Render headers partial. Used by the CMS integration to refetch headers after editing.
    def show_headers
      render partial: 'rails_email_preview/emails/headers', locals: {mail: mail_and_body.first}
    end

    # Render email body iframe HTML. Used by the CMS integration to provide a link back to Show from Edit.
    def show_body
      prevent_browser_caching
      cms_edit_links!
      with_email_locale do
        _, body = mail_and_body
        render inline: body, layout: 'rails_email_preview/email'
      end
    end

    private

    def deliver_email!(mail)
      # support deliver! if present
      if mail.respond_to?(:deliver!)
        mail.deliver!
      else
        mail.deliver
      end
    end

    # Load mail and its body for preview
    # @return [[Mail, String]] the mail object and its body
    def mail_and_body
      mail = preview_mail
      body = mail_body_content(mail, @part_type)
      [mail, body]
    end

    # @param [Boolean] run_handlers whether to run the registered handlers for Mail object
    # @return [Mail]
    def preview_mail(run_handlers = true)
      @preview.preview_mail(run_handlers, params.except(*request.path_parameters.keys))
    end

    # @param [Mail] mail
    # @param ['html', 'plain', 'raw']
    # @return [String] version of the email for HTML
    def mail_body_content(mail, part_type)
      return "<pre id='raw_message'>#{html_escape(mail.to_s)}</pre>".html_safe if part_type == 'raw'

      body_part = if mail.multipart?
                    (part_type =~ /html/ ? mail.html_part : mail.text_part)
                  else
                    mail
                  end
      return "<pre id='error'>#{html_escape(t('rep.errors.email_missing_format', locale: @ui_locale))}</pre>" if !body_part
      if body_part.content_type =~ /plain/
        "<pre id='message_body'>#{html_escape(body_part.body.to_s)}</pre>".html_safe
      else
        body_content = body_part.body.to_s

        mail.attachments.each do |attachment|
          web_url = rails_email_preview.rep_raw_email_attachment_url(params[:preview_id], attachment.filename)
          body_content.gsub!(attachment.url, web_url)
        end

        body_content.html_safe
      end
    end

    def with_email_locale(&block)
      I18n.with_locale @email_locale, &block
    end

    # Email content locale
    def set_email_preview_locale
      @email_locale = (params[:email_locale] || RailsEmailPreview.default_email_locale || I18n.default_locale).to_s
    end

    # UI locale
    def set_locale
      @ui_locale = RailsEmailPreview.locale
      if !I18n.available_locales.map(&:to_s).include?(@ui_locale.to_s)
        @ui_locale = :en
      end
      begin
        locale_was  = I18n.locale
        I18n.locale = @ui_locale
        yield if block_given?
      ensure
        I18n.locale = locale_was
      end
    end

    # Let REP's `cms_email_snippet` know to render an Edit link
    # Todo: Refactoring is especially welcome here
    def cms_edit_links!
      RequestStore.store[:rep_edit_links] = (@part_type == 'html')
    end

    def load_preview
      @preview = ::RailsEmailPreview::Preview[params[:preview_id]] or raise ActionController::RoutingError.new('Not Found')
      @part_type = params[:part_type] || 'html'
    end
  end
end
