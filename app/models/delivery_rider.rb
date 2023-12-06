class DeliveryRider < ApplicationRecord
  validates :name, presence: true, length: { minimum: 3, maximum: 140 }

  has_many :rates
  has_many :movements, through: :rates
  has_many :zones, through: :rates, dependent: :destroy
  has_one :price, as: :priciable, dependent: :destroy
  accepts_nested_attributes_for :price, allow_destroy: true

  delegate :quantity, to: :price, prefix: :price

  scope :ordered, -> { includes(:price).order(updated_at: :desc) }
  scope :filter_by_text, ->(text) { where('name ILIKE ?', "%#{text}%") }
end
