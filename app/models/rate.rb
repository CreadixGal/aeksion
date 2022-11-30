class Rate < ApplicationRecord
  belongs_to :customer
  belongs_to :zone
  
  has_many :movements, dependent: :destroy

  delegate :name, to: :customer, prefix: :customer

  validates :price, presence: true

  enum kind: {
    delivery: 'delivery',
    pickup: 'pickup'
  }, _default: 'delivery'
  validates :kind, presence: true

  def self.includes_all
    includes(%i[customer zone]).all
  end
end
