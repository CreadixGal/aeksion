class Zone < ApplicationRecord

  include Cost

  validates :name, presence: true

  has_many :rates
  has_many :customers, through: :rates, dependent: :destroy

  delegate :code, :name, :price, to: :customer, prefix: :customer

  validates :name, uniqueness: true

  scope :ordered, -> { order(name: :desc) }

  VALID_NAMES = %w[A_Coruña Lugo Ourense Pontevedra].freeze

  has_many :prices, as: :cost
end
