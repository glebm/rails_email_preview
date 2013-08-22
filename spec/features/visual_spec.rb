require 'spec_helper'
describe 'Take screenshots', driver: :poltergeist do
  it 'list page' do
    visit rails_email_preview.rep_root_path
    screenshot! 'list'
  end

  it 'show email page' do
    visit rails_email_preview.rep_email_path('auth_mailer_preview', 'email_confirmation')
    screenshot! 'show'
  end
end