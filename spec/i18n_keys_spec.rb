require 'spec_helper'

require 'i18n/tasks'
require 'i18n/tasks/base_task'

describe 'translation keys'  do
  let(:i18n) { I18n::Tasks::BaseTask.new }

  it 'are all present' do
    puts i18n.untranslated_keys
    expect(i18n.untranslated_keys).to have(0).keys
  end

  it 'are all used' do
    expect(i18n.unused_keys).to have(0).keys
  end
end
