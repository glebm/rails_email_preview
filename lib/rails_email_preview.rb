require 'rails_email_preview/engine'

module RailsEmailPreview
  mattr_accessor :preview_classes

  class << self
    def run_before_render(mail)
      (defined?(@hooks) && @hooks[:before_render] || []).each do |block|
        block.call(mail)
      end
    end

    def before_render(&block)
      ((@hooks ||= {})[:before_render] ||= []) << block
    end

    def setup
      yield self
    end
  end
end