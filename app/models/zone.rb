class Zone < ApplicationRecord
  validates :name, presence: true

  has_many :rates
  has_many :customers, through: :rates

  validates :name, uniqueness: true

  scope :ordered, -> { order(name: :desc) }

  VALID_NAMES = %i[A_Coruña Lugo Ourense Pontevedra].freeze
end
