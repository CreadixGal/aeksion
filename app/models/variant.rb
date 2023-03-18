class Variant < ApplicationRecord
  belongs_to :product
  belongs_to :zone, inverse_of: :variants
  has_one :price, as: :priciable
end
