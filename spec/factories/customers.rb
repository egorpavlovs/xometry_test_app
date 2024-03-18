FactoryBot.define do
  factory :customer do
    email { Faker::Internet.email }
    full_name { Faker::Name.name }
    registration_date { "2024-03-16 19:33:56" }
    verification_date { "2024-03-16 19:33:56" }
  end
end
