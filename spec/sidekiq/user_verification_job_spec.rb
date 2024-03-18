require 'rails_helper'
RSpec.describe UserVerificationJob, type: :job do
  describe '#perform' do
    let(:mail) { double('mail') }
    let(:params) { { email: 'test@test.com', username: 'test' } }

    before do
      allow(UserMailer).to receive(:verification).with(params)
                                                .and_return(mail)

      allow(mail).to receive(:verification).and_return(mail)
      allow(mail).to receive(:deliver_now)
    end

    it 'sends a verification email' do
      described_class.new.perform(params.to_json)
      expect(UserMailer).to have_received(:verification).with(params)
      expect(mail).to have_received(:deliver_now)
    end
  end
end
