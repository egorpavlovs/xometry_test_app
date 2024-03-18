class User < ApplicationRecord
  has_many :api_tokens

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
