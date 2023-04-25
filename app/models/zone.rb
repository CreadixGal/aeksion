class Zone < ApplicationRecord
  has_one :price, as: :priciable
  has_many :rates
  has_many :variants, dependent: :destroy, inverse_of: :zone
  has_many :products, through: :variants
  has_many :customers, through: :rates, dependent: :destroy

  delegate :code, :name, to: :customer, prefix: :customer
  delegate :quantity, to: :price

  validates :name, uniqueness: true, presence: true

  scope :ordered, -> { includes(:price).where.not(name: 'DEFAULT').order(name: :desc) }

  VALID_NAMES = %w[A_Coruña Lugo Ourense Pontevedra].freeze
end
