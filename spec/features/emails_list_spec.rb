require 'spec_helper'

describe 'emails list', :type => :feature do
  it 'shows emails' do
    visit rails_email_preview.rep_root_path
    [I18n.t('rails_email_preview.emails.index.list_title'), 'Auth', 'Email confirmation', 'Newsletter', 'Weekly newsletter', '4 emails in 2 mailers'].each do |text|
      expect(page).to have_content text
    end
  end

  it 'uses REP template by default' do
    visit rails_email_preview.rep_root_path
    expect(page).to have_title I18n.t('layouts.rails_email_preview.application.head_title')

    favicon = find 'head > link[rel=icon]', visible: :all
    expect(favicon[:href]).to start_with 'data:image/png;base64,'

    style = find 'head > style', visible: :all
    expect(style.text(:all)).to include '#rep-src-iframe-container'
  end

  it 'uses app template when specified' do
    with_layout 'admin' do
      visit rails_email_preview.rep_root_path
      expect(page).to have_title 'Dummy Admin'
    end
  end
end
