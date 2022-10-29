class Customer < ApplicationRecord
  validates :name, presence: true

  has_many :rates
  has_many :zones, through: :rates

  scope :ordered, -> { order(updated_at: :desc) }
end