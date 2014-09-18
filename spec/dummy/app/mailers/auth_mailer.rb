class AuthMailer < ApplicationMailer
  def email_confirmation(email, token)
    @token = token
    attachments['token.txt'] = @token
    attachments.inline['cat.png'] = File.read(Rails.application.root.join('app/assets/images/cat.png').to_s, mode: 'rb')
    mail reply_to: 'support@site.com', to: email, subject: 'Dummy Email Confirmation'
  end
  def password_reset(email)
    mail reply_to: 'support@site.com', to: email
  end
end
