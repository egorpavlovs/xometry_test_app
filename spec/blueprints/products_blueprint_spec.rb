require 'rails_helper'

RSpec.describe ProductsBlueprint do
  describe '.render_as_json' do
    subject { described_class.render_as_json([product]) }
    let!(:product) { create(:product) }

    it 'returns orders as json' do
      expect(subject).to eq([{
        'name' => product.name,
        'price' => product.price,
        'order_items_sum' => 0
      }])
    end
  end
end
