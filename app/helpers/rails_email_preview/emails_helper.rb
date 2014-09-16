module RailsEmailPreview::EmailsHelper

  MIME_LABELS = { 'text/html' => 'HTML', 'text/plain' => 'Text', 'raw' => 'Raw'}

  def format_label(mime_type)
    MIME_LABELS[mime_type]
  end

  def change_locale_attr(locale)
    {href:  rails_email_preview.rep_email_url(params.merge(part_type: @part_type, email_locale: locale)),
     class: rep_btn_class(@email_locale == locale.to_s)}
  end

  def change_format_attr(mime)
    {href: rails_email_preview.rep_email_url(params.merge(part_type: mime)),
     class: rep_btn_class(@part_type == mime)}
  end

  def locale_name(locale)
    if defined?(TwitterCldr)
      TwitterCldr::Shared::LanguageCodes.to_language(locale.to_s, :bcp_47)
    else
      locale.to_s
    end
  end

  def attachment_links
    @mail.attachments.map do |attachment|
      url = rails_email_preview.rep_raw_email_attachment_path(params[:preview_id], attachment.filename)
      link_to(attachment.filename, url)
    end.join('').html_safe
  end

  def headers_name_value
    {
        t('rep.headers.subject')     => @mail.subject || '(no subject)',
        t('rep.headers.from')        => @mail.from,
        t('rep.headers.reply_to')    => @mail.reply_to,
        t('rep.headers.to')          => @mail.to,
        t('rep.headers.cc')          => @mail.cc,
        t('rep.headers.bcc')         => @mail.bcc,
        t('rep.headers.attachments') => attachment_links
    }.delete_if { |k, v| v.blank? }
  end

  def format_header(value)
    if value.is_a?(Array)
      value.map(&:to_s) * ', '
    else
      value.to_s
    end
  end

  def split_in_halves(elements, &weight)
    tot_w  = elements.map(&weight).sum
    cols   = [elements.dup, []]
    col2_w = 0
    cols[0].reverse_each do |cl|
      n = weight.call(cl)
      break if col2_w + n > tot_w / 2
      col2_w += n
      cols[1] << cols[0].pop
    end
    cols[1].reverse!
    cols
  end

  # style
  def rep_style
    RailsEmailPreview.style
  end

  def rep_btn_class(active = false)
    rep_style[:"btn_#{active ? 'active' : 'default'}_class"]
  end

  def rep_row_class
    rep_style[:row_class]
  end

  def rep_col_class(n)
    rep_style[:column_class] % {n: n}
  end

  def rep_btn_group_class
    rep_style[:btn_group_class]
  end
end
