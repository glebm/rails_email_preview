class AuthMailer < ApplicationMailer
  def email_confirmation(email, token)
    @token = token
    mail reply_to: 'support@site.com', to: email, subject: 'Dummy Email Confirmation'
  end
  def password_reset(email)
    mail reply_to: 'support@site.com', to: email
  end
end
