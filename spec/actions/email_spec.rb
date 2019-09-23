require 'spec_helper'

RSpec.describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    CommunicationApp
  end

  context "POST to /email" do
    let(:invalid_response) { post "/email" }
          
    it 'checks invalid response' do
      expect(JSON.parse(invalid_response.body)['status']).to eq 422
    end

    it 'checks valid response for postmark api request' do
      postmark_params = { "From": "#{Faker::Name.name} <#{ENV['registered_pm_sender']}>", 
                          "To": "#{Faker::Name.name} <#{ENV['to_email']}>", 
                          "Subject": Faker::Name.name, 
                          "HtmlBody": Faker::Lorem.paragraph }
      pm_headers = { "Accept": "application/json",
                     "Content-Type": "application/json",
                     "X-Postmark-Server-Token": ENV['POSTMARK_TOKEN']
                    }
      VCR.use_cassette("postmark_email") do
        response = Net::HTTP.post URI('https://api.postmarkapp.com/email'), postmark_params.to_json, pm_headers
        expect(response.kind_of?(Net::HTTPSuccess)).to eq true
      end
    end

    it 'checks valid response for sendgrid api request' do
      sendgrid_params = {"personalizations": 
                          [{ "to": [{ "email": ENV['to_email'], "name": Faker::Name.name }] }],
                          "from": {"email": ENV['registered_sg_sender'], "name": Faker::Name.name},
                          "subject": Faker::Name.name,
                          "content": [{"type": "text/html", "value": Faker::Lorem.paragraph}]}
    
      sg_headers = { "Content-Type": "application/json", 
                   "Authorization": "Bearer #{ENV['SG_KEY']}"}
      VCR.use_cassette "sendgrid_email" do
        response = Net::HTTP.post URI('https://api.sendgrid.com/v3/mail/send'), sendgrid_params.to_json, sg_headers
        expect(response.kind_of?(Net::HTTPSuccess)).to eq true
      end      
    end
  end
end
