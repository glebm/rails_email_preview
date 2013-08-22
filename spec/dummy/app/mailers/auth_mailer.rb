class AuthMailer < ApplicationMailer
  def email_confirmation(email, token)
    @token = token
    mail to: email, subject: 'Dummy Email Confirmation'
  end
end