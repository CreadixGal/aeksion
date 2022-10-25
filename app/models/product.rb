class Product < ApplicationRecord
  has_one_attached :image

  validates :code, :price, :stock, presence: true

  enum :kind, { pale: 1, box: 2 }, field: { type: String, default: 'pale' }, map: :string, source: :kind
end
