require 'rails_helper'

RSpec.describe 'User creation' do
  describe 'POST /sign_up' do
    let(:username) { 'user' }
    let(:email) { 'test@test.test' }
    let(:password) { 'password' }

    before do
      allow(AuthService).to receive(:call)
        .with(action: :create_user, credentials: { username: username, email: email, password: password })
        .and_return(result)

      allow(UserVerificationJob).to receive(:perform_async).with({ email: email, username: username }.to_json)

      post '/sign_up', params: { user: { username: username, email: email, password: password } }
    end

    context 'when user is created successfully' do
      let(:result) { Utils::Result.success(User.new(username: username, email: email))}

      it 'returns a success response' do
        expect(response).to have_http_status(:created)
        expect(response.body).to eq({ message: 'User created successfully' }.to_json)
      end
    end

    context 'when username or email is already taken' do
      let(:result) { Utils::Result.failure('Username or email already taken') }

      it 'returns an error response' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to eq({ message: 'Username or email already taken' }.to_json)
      end
    end
  end
end

