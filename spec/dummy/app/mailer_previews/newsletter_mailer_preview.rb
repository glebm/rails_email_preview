class NewsletterMailerPreview
  def weekly_newsletter
    NewsletterMailer.weekly_newsletter 'test-user@test.com'
  end

end
