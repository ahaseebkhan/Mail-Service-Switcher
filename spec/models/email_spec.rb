require 'spec_helper'

RSpec.describe 'The HelloWorld App' do
  include Rack::Test::Methods

  def app
    CommunicationApp
  end

  context "Validations" do
    it "is valid with valid attributes" do
      email = build(:email)
      expect(email).to be_valid
    end

    it "is valid with valid attributes" do
      email = build(:email, :sendgrid)
      expect(email.sendgrid?).to eq(true)
    end

    it "is valid with valid attributes" do
      email = build(:email, :postmark)
      expect(email.postmark?).to eq(true)
    end

    it "is invalid with invalid attributes" do
      email = build(:email)
      expect(email).to be_valid
    end
  end
end
