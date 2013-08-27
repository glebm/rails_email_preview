module WithLayout
  def with_layout(layout)
    RailsEmailPreview.layout = layout
    yield
  ensure
    RailsEmailPreview.layout = nil
  end
end