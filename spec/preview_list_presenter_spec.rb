require 'spec_helper'

describe 'PreviewListPresenter' do
  Presenter = RailsEmailPreview::PreviewListPresenter
  Preview   = RailsEmailPreview::Preview
  context 'columns' do
    context 'when possible to balance equally' do
      it 'are balanced equally' do
        previews = [
            a = Preview.new(preview_class_name: 'A', preview_method: 'x'),
            b = Preview.new(preview_class_name: 'B', preview_method: 'x')
        ]
        expect(Presenter.new(previews).columns.to_a).to eq([[['A', [a]]], [['B', [b]]]])
      end
    end
    context 'when impossible to balance equally' do
      it 'are balanced with extra previews in the first column' do
        previews = [
            a1 = Preview.new(preview_class_name: 'A', preview_method: 'x'),
            a2 = Preview.new(preview_class_name: 'A', preview_method: 'y'),
            b = Preview.new(preview_class_name: 'B', preview_method: 'x')
        ]
        expect(Presenter.new(previews).columns.to_a).to eq([[['A', [a1, a2]]], [['B', [b]]]])
      end
    end
  end
end
