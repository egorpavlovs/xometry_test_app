require 'rails_helper'

RSpec.describe AuthService do
  describe '.call' do
    let(:username) { 'user' }
    let(:email) { 'test@test.test' }
    let(:password) { 'password' }

    context 'when action is invalid' do
      let(:result) { described_class.call(action: :invalid) }

      it 'returns an error result' do
        expect(result.success?).to be false
        expect(result.error).to eq('Invalid action')
      end
    end

    context 'when action is create_user' do
      let(:result) do
        described_class.call(
          action: :create_user,
          credentials: { username: username, email: email, password: password }
        )
      end

      context 'when user is created successfully' do
        it 'returns a success result' do
          expect(result.success?).to be true
          expect(result.value).to be_a(User)
        end
      end

      context 'when username or email is already taken' do
        before { User.create(username: username, email: email, encrypted_password: 'password') }

        it 'returns an error result' do
          expect(result.success?).to be false
          expect(result.error).to eq('Username or email already taken')
        end
      end

      context 'when data in wrong format' do
        let(:email) { 'test' }

        it 'returns an error result' do
          expect(result.success?).to be false
          expect(result.error).to eq('Email is invalid')
        end
      end
    end

    context 'when action is verification' do
      let!(:user) { create(:user, email: email) }
      let(:result) do
        described_class.call(action: :verification, credentials: { email: email })
      end

      context 'when user is not verified' do
        it 'returns a success result' do
          expect(result.success?).to be true
          expect(result.value).to eq('User verified successfully')
        end
      end

      context 'when user is already verified' do
        let!(:user) do
          create(:user, :verified, email: email)
        end

        it 'returns an error result' do
          expect(result.success?).to be false
          expect(result.error).to eq('User already verified')
        end
      end
    end

    context 'when action is get_token' do
      let!(:user) do
        create(:user, :verified, email: email, encrypted_password: Digest::MD5.hexdigest(password))
      end
      let(:result) do
        described_class.call(action: :get_token, credentials: { email: email, password: password })
      end

      context 'when user is verified' do
        it 'returns a success result' do
          expect(result.success?).to be true
          expect(result.value).to be_a(String)
          expect(user.api_tokens.last.token).to eq(result.value)
        end
      end

      context 'when user is not verified' do
        let(:user) do
          create(:user, email: email, encrypted_password: Digest::MD5.hexdigest('password'))
        end

        it 'returns an error result' do
          expect(result.success?).to be false
          expect(result.error).to eq('User not verified')
        end
      end

      context 'when invalid user credentials' do
        shared_examples 'with wrong credentials' do
          it 'returns an error result' do
            expect(result.success?).to be false
            expect(result.error).to eq('Invalid credentials')
          end
        end

        context 'when email is invalid' do
          let(:result) do
            described_class.call(
              action: :get_token, credentials: { email: 'another@email.com', password: password }
            )
          end

          it_behaves_like 'with wrong credentials'
        end

        context 'when password is invalid' do
          let(:result) do
            described_class.call(
              action: :get_token, credentials: { email: email, password: 'another_password' }
            )
          end

          it_behaves_like 'with wrong credentials'
        end
      end
    end
  end
end
