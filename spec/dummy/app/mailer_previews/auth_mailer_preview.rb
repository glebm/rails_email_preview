class AuthMailerPreview
  def email_confirmation
    AuthMailer.email_confirmation 'test-user@test.com', @token || '73570k3n'
  end

  def password_reset
    AuthMailer.password_reset 'test-user@test.com'
  end
end
