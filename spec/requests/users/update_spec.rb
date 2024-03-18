require 'rails_helper'

RSpec.describe 'User updation' do
  describe 'POST /verification' do
    context 'when user is verified successfully' do
      let(:user) { create(:user) }

      before do
        allow(AuthService).to receive(:call)
          .with(action: :verification, credentials: { email: user.email })
          .and_return(
            Utils::Result.success('User verified successfully')
          )

        post '/verification', params: { user: { email: user.email } }
      end

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ message: 'User verified successfully' }.to_json)
      end
    end

    context 'when user is not verified' do
      let(:user) { create(:user, verified: false) }

      before do
        allow(AuthService).to receive(:call)
          .with(action: :verification, credentials: { email: user.email })
          .and_return(
            Utils::Result.failure('User not verified')
          )

        post '/verification', params: { user: { email: user.email } }
      end

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ message: 'User not verified' }.to_json)
      end
    end
  end
end
