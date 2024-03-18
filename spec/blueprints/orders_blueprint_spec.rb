require 'rails_helper'

RSpec.describe OrdersBlueprint do
  describe '.render_as_json' do
    subject { described_class.render_as_json([order]) }
    let(:order_item) { create(:order_item, product: create(:product)) }
    let(:customer) { create(:customer) }
    let!(:order) { create(:order, customer: customer, order_items: [order_item]) }

    it 'returns orders as json' do
      expect(subject).to eq([{
        'cancelation_date' => order.cancelation_date.to_s,
        'completion_date' => order.completion_date.to_s,
        'customer_name' => customer.full_name,
        'name' => order.name,
        'order_items' => [{ 'name' => order_item.product.name, 'quantity' => order_item.quantity }],
        'state' => order.state
      }])
    end
  end
end
