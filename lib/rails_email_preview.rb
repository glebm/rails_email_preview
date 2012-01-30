require 'rails_email_preview/engine'

module RailsEmailPreview
  mattr_accessor :preview_classes

  def self.setup
    yield self
  end
end