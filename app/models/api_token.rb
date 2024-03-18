class ApiToken < ApplicationRecord
  belongs_to :user

  before_create :generate_token

private

  def generate_token
    self.token = Digest::MD5.hexdigest(SecureRandom.hex)
  end
end
