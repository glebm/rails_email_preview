class RailsEmailPreview::EmailsController < RailsEmailPreview::ApplicationController
  before_filter :load_preview_class, :except => :index
  def index
    @preview_classes = (RailsEmailPreview.preview_classes || [])
  end

  def show
    @mail = @preview_class.new.send(params[:mail_action])
  end

  def show_raw
    @mail = @preview_class.new.send(params[:mail_action])
    body_part = @mail
    if @mail.multipart?
      content_type = Rack::Mime.mime_type(params[:format])
      body_part = @mail.parts.find { |part| part.content_type.match(content_type) } || @mail.parts.first
    end
    body = body_part.body
    if body_part.content_type =~ /plain/
      body = "<pre id='message_body'>#{body}</body>"
    end
    render :text => body, :layout => false
  end

  private
  def load_preview_class
    @preview_class = (RailsEmailPreview.preview_classes || []).find {|pc| pc.name.underscore == params[:mail_class]}
  end
end