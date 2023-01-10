require 'spec_helper'

describe 'rails g rails_email_preview:update_previews' do
  context 'new mailer class' do
    let(:test_mailer_path) { 'app/mailers/new_mailer.rb' }
    let(:test_mailer_src) { <<-RUBY }
class NewMailer < ApplicationMailer
  def notification(user)
    mail to: user.email
  end
end
    RUBY
    let(:expected_preview_path) { 'app/mailer_previews/new_mailer_preview.rb' }
    let(:expected_preview_src) { <<-RUBY }
class NewMailerPreview
  def notification
    NewMailer.notification user
  end
end
    RUBY
    before do
      File.open(test_mailer_path, 'w') { |f| f.write test_mailer_src }
    end
    after do
      [expected_preview_path, test_mailer_path].each do |f|
        FileUtils.rm(f) if File.exist?(f)
        Object.send(:remove_const, :NewMailer) if defined?(NewMailer)
        Object.send(:remove_const, :NewMailerPreview) if defined?(NewMailerPreview)
      end
    end
    it 'creates a stub preview class' do
      if Rails.respond_to?(:autoloaders) && Rails.autoloaders.respond_to?(:zeitwerk_enabled?)
        require Rails.root.join(test_mailer_path)
      end
      Rails::Generators.invoke('rails_email_preview:update_previews', [])
      path = Rails.root.join(expected_preview_path)
      expect(File).to exist(path)
      expect(File.read(path)).to(
          eq(expected_preview_src)
      )
    end
  end
end
