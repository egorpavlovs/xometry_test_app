require 'rails_helper'

RSpec.describe 'Customers list' do
  describe 'GET /customers' do
    context 'when customers are listed successfully' do
      let!(:customers) { create_list(:customer, 12) }

      before do
        allow(ApiToken).to receive(:find_by_token).and_return('token')

        get '/customers', headers: { 'Authorization' => 'token' }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body.count).to eq(5)
        expect(response.body).to eq(customers.first(5).to_json)
      end

      context 'with pagination' do
        before do
          get '/customers', params: { page: 3 }, headers: { 'Authorization' => 'token' }
        end

        it 'returns a success response' do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.count).to eq(2)
          expect(response.body).to eq(customers.last(2).to_json)
        end
      end
    end

    context 'when the request is unauthorized' do
      before do
        get '/customers'
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ message: 'Bad credentials' }.to_json)
      end
    end
  end
end
