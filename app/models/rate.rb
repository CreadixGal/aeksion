class Rate < ApplicationRecord
  belongs_to :customer, optional: true, inverse_of: :rates
  belongs_to :delivery_rider, optional: true, inverse_of: :rates
  belongs_to :zone, inverse_of: :rates

  has_many :movements, dependent: :destroy
  has_one :price, as: :priciable, dependent: :destroy

  delegate :name, to: :customer, prefix: :customer
  delegate :name, to: :delivery_rider, prefix: :delivery_rider
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

  validate :validate_customer_or_delivery_rider
  validate :validate_uniqueness_rate
  before_save :update_name

  def self.includes_all
    includes(%i[customer zone]).all
  end

  private

  def update_name
    resource_name = customer.name if customer.present?
    resource_name = delivery_rider.name if delivery_rider.present?
    zone_name = zone.name.downcase.tr('^a-z', '').slice(0, 2)
    self.name = "#{resource_name}-#{zone_name}"
  end

  def validate_uniqueness_rate
    return if Rate.exists?(customer:, zone:, kind:)

    errors.add(:base, 'Ya existe una tarifa con estos datos')
  end

  def validate_customer_or_delivery_rider
    if customer_id.nil? && delivery_rider_id.nil?
      errors.add(:base, 'Debe proporcionar un Cliente o un Repartidor.')
    elsif customer_id.present? && delivery_rider_id.present?
      errors.add(:base, 'Solo puede establecer una relación, Cliente o Repartidor, no ambas.')
    end
  end
end
