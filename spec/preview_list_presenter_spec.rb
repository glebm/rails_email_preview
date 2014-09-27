require 'spec_helper'

describe 'PreviewListPresenter' do
  Presenter = RailsEmailPreview::PreviewListPresenter
  Preview   = RailsEmailPreview::Preview
  context 'columns' do
    it 'are balanced equally when possible' do
      previews = [
          a = Preview.new(preview_class_name: 'A', preview_method: 'x'),
          b = Preview.new(preview_class_name: 'B', preview_method: 'x')
      ]
      expect(Presenter.new(previews).columns.to_a).to eq([[['A', [a]]], [['B', [b]]]])
    end
    context 'when impossible to balance equally' do
      it 'the first column has more previews if possible' do
        previews = [
            a = Preview.new(preview_class_name: 'A', preview_method: 'x'),
            b = Preview.new(preview_class_name: 'B', preview_method: 'x'),
            c = Preview.new(preview_class_name: 'C', preview_method: 'x')
        ]
        expect(Presenter.new(previews).columns.to_a).to eq([[['A', [a]], ['B', [b]]], [['C', [c]]]])
      end
      it 'two columns even if the first column has fewer previews' do
        previews = [
            a  = Preview.new(preview_class_name: 'A', preview_method: 'x'),
            b1 = Preview.new(preview_class_name: 'B', preview_method: 'x'),
            b2 = Preview.new(preview_class_name: 'B', preview_method: 'y'),
            b3 = Preview.new(preview_class_name: 'B', preview_method: 'z'),
            b4 = Preview.new(preview_class_name: 'B', preview_method: 't')
        ]
        expect(Presenter.new(previews).columns.to_a).to eq([[['A', [a]]], [['B', [b1, b2, b3, b4]]]])
      end
    end
    it 'does not fail with no previews' do
      expect(Presenter.new([]).columns.to_a).to eq([[], []])
    end
  end
end
