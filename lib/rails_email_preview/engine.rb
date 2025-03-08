module ::RailsEmailPreview
  class Engine < Rails::Engine
    isolate_namespace RailsEmailPreview
    load_generators
  end
end
