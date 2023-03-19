class Variant < ApplicationRecord
  belongs_to :product
  belongs_to :zone, inverse_of: :variants
  has_one :price, as: :priciable

  delegate :name, to: :zone, prefix: :zone
  delegate :quantity, to: :price
end
