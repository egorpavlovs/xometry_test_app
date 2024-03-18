class Order < ApplicationRecord
  before_create :generate_name

  belongs_to :customer
  has_many :order_items

  STATES = %w[draft completed cancelled].freeze

  validates :state, inclusion: { in: STATES }, allow_nil: true

  accepts_nested_attributes_for :order_items

  def generate_name
    return if name.present?

    self.name = SecureRandom.hex
  end
end
