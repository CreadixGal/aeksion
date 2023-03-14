class Zone < ApplicationRecord
  has_one :price, as: :priciable
  has_many :rates
  has_many :products
  has_many :customers, through: :rates, dependent: :destroy

  delegate :code, :name, to: :customer, prefix: :customer

  validates :name, uniqueness: true, presence: true

  scope :ordered, -> { order(name: :desc) }

  VALID_NAMES = %w[A_Coruña Lugo Ourense Pontevedra].freeze
end
