class Customer < ApplicationRecord
  validates :name, presence: true

  has_many :rates
  has_many :zones, through: :rates, dependent: :destroy
  has_one :price, as: :priciable

  before_create :set_product_rate
  after_create :default_price

  delegate :quantity, to: :price, prefix: :price

  scope :ordered, -> { includes(:price).order(updated_at: :desc) }

  private

  def default_price
    Price.create! quantity: 0, priciable: self
  end

  def set_product_rate
    rates.build(zone: Zone.find_by(name: 'Product'), kind: 'pickup')
  end
end
