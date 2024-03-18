FactoryBot.define do
  factory :order do
    name { Faker::Name.name }
    state { Order::STATES.last }
    completion_date { "2024-03-16 20:09:17" }
    cancelation_date { "2024-03-16 20:09:17" }
    customer { create(:customer) }
  end
end
