module RepUrlsHelper
  # to make it easy to change root url without breaking backwards compatibility, declare them here as aliases
  def rep_root_url
    rails_email_preview.rep_emails_url
  end

  def rep_root_path
    rails_email_preview.rep_emails_path
  end
end
