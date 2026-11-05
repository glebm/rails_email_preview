require 'spec_helper'

describe 'email test send', :type => :feature do
  let(:url_args) { {preview_id: 'auth_mailer_preview-email_confirmation'} }
  it 'shows email' do
    page.driver.post rails_email_preview.rep_test_deliver_path(url_args), {recipient_email: 'test@test.com'}
    expect(page.driver.response.location).to eq rails_email_preview.rep_email_url(url_args)
  end

  describe 'send form', js: true do
    let(:send_button) { I18n.t('rails_email_preview.emails.send_form.send_btn', locale: :en) }
    let(:confirmation) { I18n.t('rails_email_preview.emails.send_form.send_are_you_sure', locale: :en) }

    before do
      visit rails_email_preview.rep_email_path(url_args)
      fill_in 'recipient_email', with: 'test@test.com'
    end

    it 'does not send when the confirmation is dismissed' do
      dismiss_confirm(confirmation) { click_button send_button }
      expect(page).to have_field 'recipient_email', with: 'test@test.com'
      expect(page).to have_no_css '#flash_notice'
    end

    it 'sends when the confirmation is accepted' do
      accept_confirm(confirmation) { click_button send_button }
      expect(page).to have_css '#flash_notice', text: 'Sent to test@test.com via test'
    end
  end
end
