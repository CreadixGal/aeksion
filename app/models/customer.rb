class Customer < ApplicationRecord
  validates :name, presence: true

  has_many :rates

  scope :ordered, -> { order(updated_at: :desc) }
end
