module RailsEmailPreview
  class DeliveryHandler
    def initialize(mail, headers)
      @mail = mail
      @mail.headers(headers)
      @mail.delivery_handler = self
    end
      
    attr_accessor :mail
      
    def deliver_mail(mail)
      yield
    end
  end
end