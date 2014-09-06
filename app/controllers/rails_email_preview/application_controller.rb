module RailsEmailPreview
  class ApplicationController < ::RailsEmailPreview.parent_controller.constantize
    layout 'rails_email_preview/application'

    protected

    def prevent_browser_caching
      # Prevent back-button browser caching:
      # HTTP/1.1
      response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate'
      # Date in the past
      response.headers['Expires']       = 'Mon, 26 Jul 1997 05:00:00 GMT'
      # Always modified
      response.headers['Last-Modified'] = Time.now.httpdate
      # HTTP/1.0
      response.headers['Pragma']        = 'no-cache'
    end
  end
end
