class Movement < ApplicationRecord
  belongs_to :rate

  has_many :product_movements
  has_many :products, through: :product_movements, dependent: :destroy
end
