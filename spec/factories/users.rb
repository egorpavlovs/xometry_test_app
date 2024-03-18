FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Name.name }
    encrypted_password { Faker::Internet.password }

    trait :verified do
      verified { true }
    end
  end
end
