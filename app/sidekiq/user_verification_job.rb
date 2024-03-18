class UserVerificationJob
  include Sidekiq::Job

  def perform(args)
    args = JSON.parse(args).with_indifferent_access
    UserMailer.verification(username: args[:username], email: args[:email]).deliver_now
  # TODO: Add error handling like:
  # rescue Error => e
  #   Rollbar.send(...)
  end
end
