Dummy::Application.routes.draw do

  mount RailsEmailPreview::Engine, at: 'rep-emails'
end
