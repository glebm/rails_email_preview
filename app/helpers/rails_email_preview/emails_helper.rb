module RailsEmailPreview::EmailsHelper
  def current_email_name
    "#{preview_class_human_name}: #{@mail_action.to_s.humanize}"
  end

  def preview_class_human_name(preview_class = @preview_class)
    preview_class.to_s.underscore.sub(/(_mailer)?_preview$/, '').humanize
  end

  def change_locale_attr(locale)
    {href:  rails_email_preview.rep_email_url(params.merge(part_type: @part_type, email_locale: locale)),
     class: ('active btn-primary' if @email_locale == locale.to_s)}
  end

  def change_format_attr(mime)
    {href: rails_email_preview.rep_email_url(params.merge(part_type: mime)),
     class: ('active btn-primary' if @part_type == mime)}
  end

  def locale_name(locale)
    if defined?(TwitterCldr)
      TwitterCldr::Shared::LanguageCodes.to_language(locale.to_s, :bcp_47)
    else
      locale.to_s
    end
  end

  def headers_name_value
    I18n.with_locale @email_locale do
      {
          'Subject'  => @mail.subject || '(no subject)',
          'From'     => @mail.from,
          'Reply to' => @mail.reply_to,
          'To'       => @mail.to,
          'CC'       => @mail.cc,
          'BCC'      => @mail.bcc
      }.delete_if { |k, v| v.blank? }
    end
  end

  def format_header(value)
    if value.is_a?(Array)
      value.map(&:to_s) * ', '
    else
      value.to_s
    end
  end

  def email_methods(m)
    m.constantize.instance_methods(false).map(&:to_s).sort
  end

  def total_emails
    @total_emails ||= @preview_class_names.sum { |p| email_methods(p).length }
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
end
