class Customer < ApplicationRecord

  include Cost

  validates :name, presence: true

  has_many :rates
  has_many :zones, through: :rates, dependent: :destroy

  scope :ordered, -> { order(updated_at: :desc) }

  has_many :prices, as: :cost
end
