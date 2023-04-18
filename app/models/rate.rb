class Rate < ApplicationRecord
  belongs_to :customer, inverse_of: :rates
  belongs_to :zone, inverse_of: :rates

  has_many :movements, dependent: :destroy
  has_one :price, as: :priciable, dependent: :destroy

  delegate :name, to: :customer, prefix: :customer
  delegate :name, to: :zone, prefix: :zone
  delegate :quantity, to: :price

  enum kind: {
    delivery: 'delivery',
    pickup: 'pickup',
    return: 'return'
  }, _default: 'delivery'
  validates :kind, presence: true

  scope :delivery, -> { includes([:price]).where(kind: 'delivery').order(created_at: :desc) }
  scope :pickup, -> { where(kind: 'pickup').order(created_at: :desc) }
  scope :return, -> { where(kind: 'return').order(created_at: :desc) }

  before_save :validate_uniqueness_rate
  before_save :update_name

  def self.includes_all
    includes(%i[customer zone]).all
  end

  private

  def update_name
    customer_name = customer.name
    zone_name = zone.name.downcase.tr('^a-z', '').slice(0, 2)
    self.name = "#{customer_name}-#{zone_name}"
  end

  def validate_uniqueness_rate
    return unless Rate.where(customer: customer, zone: zone, kind: kind).exists?

    errors.add(:base, 'Ya existe una tarifa con estos datos')
  end
end
