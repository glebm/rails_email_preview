module RailsEmailPreview::EmailsHelper

  FORMAT_LABELS = { 'html' => 'HTML', 'plain' => 'Text', 'raw' => 'Raw'}

  def format_label(mime_type)
    FORMAT_LABELS[mime_type]
  end

  def change_locale_attr(locale)
    {href:  rails_email_preview.rep_email_path(preview_params.merge(part_type: @part_type, email_locale: locale)),
     class: rep_btn_class(@email_locale == locale.to_s)}
  end

  def change_format_attr(format)
    {href: rails_email_preview.rep_email_path(preview_params.merge(part_type: format)),
     class: rep_btn_class(@part_type == format)}
  end

  def locale_name(locale)
    if defined?(TwitterCldr)
      TwitterCldr::Shared::LanguageCodes.to_language(locale.to_s, :bcp_47)
    else
      locale.to_s
    end
  end

  def human_headers(mail, &block)
    {t('rep.headers.subject')     => mail.subject || '(no subject)',
     t('rep.headers.from')        => mail.from,
     t('rep.headers.reply_to')    => mail.reply_to,
     t('rep.headers.to')          => mail.to,
     t('rep.headers.cc')          => mail.cc,
     t('rep.headers.bcc')         => mail.bcc,
     t('rep.headers.attachments') => attachment_links(mail)
    }.each do |name, value|
      block.call(name, format_header_value(value)) unless value.blank?
    end
  end

  def attachment_links(mail)
    mail.attachments.map do |attachment|
      url = rails_email_preview.rep_raw_email_attachment_path(preview_params.merge(filename: attachment.filename))
      link_to(attachment.filename, url, title: attachment.header.to_s)
    end.to_sentence.html_safe
  end

  def format_header_value(value)
    if value.is_a?(Array)
      value.map(&:to_s) * ', '
    else
      value.to_s
    end
  end

  # style
  def rep_style
    RailsEmailPreview.style
  end

  def rep_btn_class(active = false)
    [rep_style[:btn_default_class], (rep_style[:btn_active_class_modifier] if active)].compact * ' '
  end

  def rep_btn_group_class
    rep_style[:btn_group_class]
  end

  def with_index_hook(key, &block)
    render_hook key, list: @list, previews: @previews, &block
  end

  def with_show_hook(key, &block)
    render_hook key, mail: @mail, preview: @preview, &block
  end

  def render_hook(key, args, &block)
    view_hooks.render(key, args, self, &block)
  end

  def hook?(key)
    view_hooks.for?(key)
  end

  def view_hooks
    RailsEmailPreview.view_hooks
  end
end
