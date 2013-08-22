class AuthMailerPreview
  def email_confirmation
    AuthMailer.email_confirmation 'test-user@test.com', '73570k3n'
  end

end
