require 'faker'

FactoryBot.define do
  factory :email do
    to { Faker::Internet.email }
    from  { Faker::Internet.email }
    to_name { Faker::Name.name }
    from_name { Faker::Name.name }
    subject { Faker::Name.name }
    body { Faker::Lorem.paragraph }
    
    trait :sendgrid do
      service { :sendgrid }
    end

    trait :postmark do
      service { :postmark }
    end
  end
end
