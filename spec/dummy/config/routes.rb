Dummy::Application.routes.draw do

  mount RailsEmailPreview::Engine, at: 'rep-emails'
  root to: redirect('/rep-emails')
end
