FactoryBot.define do
  factory :order_item do
    quantity { Faker::Number.number(digits: 2).to_s }
    product { create(:product) }
    order { create(:order) }
  end
end
