require 'rails_helper'

RSpec.describe 'Products list' do
  describe 'GET /products' do
    context 'when products are listed successfully' do
      let!(:products) { create_list(:product, 12) }

      before do
        allow(ApiToken).to receive(:find_by_token).and_return('token')
        allow(SearchService::Products).to receive(:call).and_return(Utils::Result.success([{ foo: :bar }]))
        allow(ProductsBlueprint).to receive(:render_as_json).with([{ foo: :bar }]).and_return(
          [{ foo: :bar }]
        )

        get '/products', headers: { 'Authorization' => 'token' }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq([{ foo: :bar }].to_json)
      end
    end

    context 'when the request is unauthorized' do
      before do
        get '/products'
      end

      it 'returns an unauthorized response' do
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to eq({ message: 'Bad credentials' }.to_json)
      end
    end
  end
end
