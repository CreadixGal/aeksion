class Variant < ApplicationRecord
  belongs_to :product
  belongs_to :zone, inverse_of: :variants
  has_one :price, as: :priciable

  delegate :name, to: :zone, prefix: :zone
  delegate :quantity, to: :price

  validates :code, presence: true
  validate :unique_zone_per_product

  private

  def unique_zone_per_product
    variant = Variant.find_by(product_id:, zone_id:)
    return unless variant.present? && variant.id != id

    errors.add(:product, 'cannot have multiple variants for the same zone')
  end
end
