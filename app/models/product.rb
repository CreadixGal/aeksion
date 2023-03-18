class Product < ApplicationRecord
  has_one_attached :image
  has_many :variants, inverse_of: :product, dependent: :destroy

  has_many :product_movements, inverse_of: :product, dependent: :destroy
  has_many :movements, through: :product_movements, dependent: :destroy
  
  validates :stock, :kind, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'El stock no puede ser negativo' }

  delegate :name, to: :zone, prefix: :zone

  enum :kind, { pallet: 1, box: 2 }, field: { type: Integer, default: 1 }, map: :string, source: :kind
end
