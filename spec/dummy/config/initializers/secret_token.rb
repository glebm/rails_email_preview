config = Dummy::Application.config

if config.respond_to?(:secret_key_base=)
  # Rails 4
  config.secret_key_base = '4380f36fda304251bf48f12ad4474b6d11447f1f959bd5b77a5d56c92b97f4c403ee0ae13d31a85ed88058ff8795bf31ec17e70e5c229b3707a77a2ee7e81724'
else
  # Rails 3
  config.secret_token = "some secret phrase of at least 30 characters"
end

