class Product < ApplicationRecord
  belongs_to :zone, optional: true, inverse_of: :products, foreign_key: :zone_id

  has_one_attached :image

  has_many :prices, as: :priciable
  has_many :product_movements, inverse_of: :product, dependent: :destroy
  has_many :movements, through: :product_movements, dependent: :destroy

  validates :code, :stock, :kind, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'El stock no puede ser negativo' }

  delegate :name, to: :zone, prefix: :zone

  enum :kind, { pallet: 1, box: 2 }, field: { type: Integer, default: 1 }, map: :string, source: :kind
end
