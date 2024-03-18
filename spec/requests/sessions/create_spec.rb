require 'rails_helper'

RSpec.describe 'Session creation' do
  describe 'POST /sign_in' do
    let(:email) { 'test@test.test' }
    let(:password) { 'password' }

    before do
      allow(AuthService).to receive(:call)
        .with(action: :get_token, credentials: { email: email, password: password })
        .and_return(result)

      post '/sign_in', params: { user: { email: email, password: password } }
    end

    context 'when user is signed in successfully' do
      let(:result) { Utils::Result.success('token') }

      it 'returns a success response' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ token: 'token' }.to_json)
      end
    end

    context 'when user is not signed in' do
      let(:result) { Utils::Result.failure('User not signed in') }

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ message: 'User not signed in' }.to_json)
      end
    end
  end
end
