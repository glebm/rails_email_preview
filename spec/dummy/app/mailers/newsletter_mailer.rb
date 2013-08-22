class NewsletterMailer < ApplicationMailer
  def weekly_newsletter(email)
    mail to: email
  end
end