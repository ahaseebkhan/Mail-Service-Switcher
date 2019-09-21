class WebhookLog < ActiveRecord::Base
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  enum service: { 
    postmark: 0, 
    sendgrid: 1
  }
end
