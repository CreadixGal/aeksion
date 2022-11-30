class Product < ApplicationRecord
  has_one_attached :image

  has_many :product_movements
  has_many :movements, through: :product_movements, dependent: :destroy

  validates :code, :price, :stock, :kind, presence: true

  enum :kind, { pallet: 1, box: 2 }, field: { type: Integer, default: 1 }, map: :string, source: :kind
end
