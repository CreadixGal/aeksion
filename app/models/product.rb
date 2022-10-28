class Product < ApplicationRecord
  has_one_attached :image

  validates :code, :price, :stock, :kind, presence: true

  enum :kind, { pallet: 1, box: 2 }, field: { type: Integer, default: 1 }, map: :string, source: :kind
end
