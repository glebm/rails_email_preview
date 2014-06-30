require 'spec_helper'

describe 'email test send', :type => :feature do
  let(:url_args) { {preview_id: 'auth_mailer_preview-email_confirmation'} }
  it 'shows email' do
    page.driver.post rails_email_preview.rep_test_deliver_path(url_args), {recipient_email: 'test@test.com'}
    expect(page.driver.response.location).to eq rails_email_preview.rep_email_url(url_args)
  end
end
