require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "verification" do
    let(:mail) { UserMailer.verification(username: 'user_test', email: 'test@test.com') }

    it "renders the headers" do
      expect(mail.subject).to eq('Welcome to Orders! Please verify your email')
      expect(mail.to).to eq(%w[test@test.com])
      expect(mail.from).to eq(%w[notifications@orders.com])

      expect(mail.body.encoded).to include("Welcome to the club buddy, user_test")
      expect(mail.body.encoded).to include('http://localhost:3000/verification?user[email]=test@test.com')
    end
  end
end
