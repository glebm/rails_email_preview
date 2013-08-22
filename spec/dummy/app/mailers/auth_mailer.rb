class AuthMailer < ApplicationMailer
  def email_confirmation(email, token)
    @token = token
    mail to: email, subject: 'Dummy Email Confirmation'
  end
  def password_reset(email)
    mail to: email
  end
end