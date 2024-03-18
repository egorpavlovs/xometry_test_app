require 'rails_helper'

RSpec.describe 'Orders list' do
  describe 'GET /orders' do
    context 'when orders are listed successfully' do
      let(:params) do
        {
          state: Order::STATES.last,
          cancelation_date_from: 1.day.ago.to_s, cancelation_date_to: 2.day.from_now.to_s
        }
      end

      before do
        allow(ApiToken).to receive(:find_by_token).and_return('token')
        allow(SearchService::Orders).to receive(:call).with(params).and_return(
          Utils::Result.success([{ foo: :bar }])
        )
        allow(OrdersBlueprint).to receive(:render_as_json).with([{ foo: :bar }]).and_return([{ foo: :bar }])

        get '/orders', params: params, headers: { 'Authorization' => 'token' }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq([{ foo: :bar }].to_json)
      end
    end

    context 'when the request is unauthorized' do
      before do
        get '/orders'
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ message: 'Bad credentials' }.to_json)
      end
    end
  end
end
