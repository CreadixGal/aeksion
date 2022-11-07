class Zone < ApplicationRecord
  validates :name, presence: true

  has_many :rates
  has_many :customers, through: :rates
end
