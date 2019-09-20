class Email < ActiveRecord::Base
  validates :to, :from, :subject, :body, :to_name, :from_name, presence: true
  validates :to, :from, format: { with: URI::MailTo::EMAIL_REGEXP }

  after_create :initiate_email

  # Mantain a hash with service name and class in order of priority
  SERVICE_HASH = {
    sendgrid: EmailServices::SendgridEmail,
    postmark: EmailServices::PostmarkEmail
  }.freeze

  enum service: { 
    postmark: 0, 
    sendgrid: 1
  }

  def initiate_email
    # Dynamicaly use the first email service that runs successfuly
    SERVICE_HASH.each do |service, service_class|
      @response = service_class.new.send_email(self.attributes)
      if @response.kind_of? Net::HTTPSuccess
        self.update(service: service, status: @response.code, api_response: @response.body)
        break
      end
    end
    
    # Throw exception when no email service runs successfuly
    raise Exception.new('Email services are down or configured incorrectly') if self.service.nil?
  end
end
