module RailsEmailPreview::MainAppRouteDelegator
  # delegate url helpers to main_app
  def method_missing(method, *args, &block)
    if method.to_s =~ /_(?:path|url)$/ && main_app.respond_to?(method)
      main_app.send(method, *args)
    else
      super
    end
  end

  def respond_to?(method)
    super || main_app.respond_to?(method)
  end
end
