class Zone < ApplicationRecord
  validates :name, presence: true

  has_many :rates
  has_many :customers, through: :rates, dependent: :destroy

  validates :name, uniqueness: true

  scope :ordered, -> { order(name: :desc) }

  VALID_NAMES = %w[A_Coruña Lugo Ourense Pontevedra].freeze
end
