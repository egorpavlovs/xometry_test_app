class UserMailer < ApplicationMailer
  default from: 'notifications@orders.com'

  def verification(username:, email:)
    @username = username
    # TODO: Add a verification token to the URL
    # TODO: Change localhost:3000 to tomen from ENV through some settingslogic gem
    @url = "http://localhost:3000/verification?user[email]=#{email}"
    mail(to: email, subject: 'Welcome to Orders! Please verify your email')


  end
end
