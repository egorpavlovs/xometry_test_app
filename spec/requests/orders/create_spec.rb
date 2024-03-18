require 'rails_helper'

RSpec.describe 'Create Order' do
  describe 'POST /orders' do
    context 'when the order is created successfully' do
      let(:customer) { create(:customer) }
      let(:product) { create(:product) }
      let(:order_params) do
        {
          order: {
            customer_id: customer.id,
            ordered_items: [{ product_id: product.id, quantity: 2 }]
          }
        }
      end

      before do
        allow(ApiToken).to receive(:find_by_token).and_return('token')

        post '/orders', params: order_params, headers: { 'Authorization' => 'token' }
      end

      it 'returns a created response' do
        expect(response).to have_http_status(:created)
        expect(response.body).to eq(Order.last.to_json)
      end
    end

    context 'when the request is unauthorized' do
      before do
        post '/orders'
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ message: 'Bad credentials' }.to_json)
      end
    end
  end
end
