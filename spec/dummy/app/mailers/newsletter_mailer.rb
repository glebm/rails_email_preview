class NewsletterMailer < ApplicationMailer
  def weekly_newsletter(email)
    mail to: email
  end
  def monthly_newsletter(email)
    mail to: email
  end
  def quarterly_newsletter(email)
    mail to: email
  end
end
