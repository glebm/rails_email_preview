module WithLayout
  def with_layout(layout)
    RailsEmailPreview::EmailsController.layout layout
    yield
  ensure
    RailsEmailPreview::EmailsController.layout nil
  end
end