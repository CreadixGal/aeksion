class DeliveryRider < ApplicationRecord
  validates :name, presence: true

  has_many :rates
  has_many :zones, through: :rates, dependent: :destroy
  has_one :price, as: :priciable, dependent: :destroy

  # before_create :set_product_rate
  after_create :default_price

  delegate :quantity, to: :price, prefix: :price

  scope :ordered, -> { includes(:price).order(updated_at: :desc) }

  private

  def default_price
    Price.create! quantity: 0, priciable: self
  end
end
