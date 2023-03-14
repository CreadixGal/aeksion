class Rate < ApplicationRecord
  belongs_to :customer, inverse_of: :rates
  belongs_to :zone, inverse_of: :rates

  has_many :movements, dependent: :destroy

  delegate :name, to: :customer, prefix: :customer
  delegate :name, to: :zone, prefix: :zone
  # TODO: solo products debe tener has many prices, rate no tengo claro si tiene precio, hai que pensar el proceso.
  has_many :prices, as: :priciable
  # validates :price, presence: true

  enum kind: {
    delivery: 'delivery',
    pickup: 'pickup',
    return: 'return'
  }, _default: 'delivery'
  validates :kind, presence: true

  scope :delivery, -> { includes(%i[zone]).where(kind: 'delivery').order(Arel.sql('zones.name ASC')) }
  scope :pickup, -> { includes(%i[zone]).where(kind: 'pickup').order(Arel.sql('zones.name ASC')) }
  scope :return, -> { includes(%i[zone]).where(kind: 'return').order(Arel.sql('zones.name ASC')) }

  def self.includes_all
    includes(%i[customer zone]).all
  end
end
