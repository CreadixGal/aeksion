class Rate < ApplicationRecord
  belongs_to :customer, inverse_of: :rates
  belongs_to :zone, inverse_of: :rates

  has_many :movements, dependent: :destroy
  has_one :price, as: :priciable

  delegate :name, to: :customer, prefix: :customer
  delegate :name, to: :zone, prefix: :zone
  delegate :quantity, to: :price

  enum kind: {
    delivery: 'delivery',
    pickup: 'pickup',
    return: 'return'
  }, _default: 'delivery'
  validates :kind, presence: true

  scope :delivery, -> { includes(zone: :price).where(kind: 'delivery').order(created_at: :desc) }
  scope :pickup, -> { includes(:zone).where(kind: 'pickup').order(created_at: :desc) }
  scope :return, -> { where(kind: 'return').order(created_at: :desc) }

  after_save :update_name

  def self.includes_all
    includes(%i[customer zone]).all
  end

  private

  def update_name
    update!(name: "#{customer.name}-#{zone.name.downcase.tr('^a-z', '').slice(0, 2)}") if name.blank?
  end
end
