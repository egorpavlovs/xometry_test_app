FactoryBot.define do
  factory :api_token do
    token { 'token' }
    user
  end
end
