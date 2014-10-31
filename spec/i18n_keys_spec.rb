require 'spec_helper'
require 'i18n/tasks'

describe 'Translation keys'  do
  let(:i18n) { I18n::Tasks::BaseTask.new }

  around(:each) do |e|
    Dir.chdir File.expand_path('..', File.dirname(__FILE__)) do
      e.run
    end
  end

  it 'are all present' do
    expect(i18n.missing_keys).to be_empty
  end

  it 'are all used' do
    expect(i18n.unused_keys).to be_empty
  end
end
