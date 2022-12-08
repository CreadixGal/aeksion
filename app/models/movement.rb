class Movement < ApplicationRecord
  belongs_to :rate

  has_many :product_movements
  has_many :products, through: :product_movements, dependent: :destroy

  delegate :name, :price, :customer_name, to: :rate, prefix: :rate

  accepts_nested_attributes_for :product_movements

  scope :delivery, -> { joins(:rate).where(rates: { kind: 'delivery' }) }
  scope :pickup, -> { joins(:rate).where(rates: { kind: 'pickup' }) }
end
