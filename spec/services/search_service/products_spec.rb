require 'rails_helper'

RSpec.describe SearchService::Products do
  describe '.call' do
    subject { described_class.call(params) }

    context 'with page' do
      let(:params) { { page: 2 } }
      let!(:products) { create_list(:product, 5, name: 'Aaaaaa First Name') }
      let!(:second_products) { create_list(:product, 3, name: 'Aaaabbb Second Name') }

      it 'returns the second page' do
        expect(subject.value).to match_array(second_products)
        expect(subject.value.last.order_items_sum).to eq(nil)
      end
    end
  end
end
