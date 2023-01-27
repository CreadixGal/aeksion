class Movement < ApplicationRecord
  include PgSearch::Model

  belongs_to :rate, inverse_of: :movements

  has_many :product_movements, inverse_of: :movement, dependent: :destroy
  has_many :products, through: :product_movements, dependent: :destroy

  has_one :customer, through: :rate

  validates :date, presence: true

  delegate :name, :price, :kind, to: :rate, prefix: :rate
  delegate :name, to: :customer, prefix: :customer
  delegate :amount, to: :product_movements
  accepts_nested_attributes_for :product_movements

  validates :date, presence: true
  # validates :code, uniqueness: true
  before_create :validate_code
  scope :delivery, -> { includes(%i[rate product_movements]).where(rates: { kind: 'delivery' }).order(date: :desc) }
  scope :pickup, -> { includes(%i[rate product_movements]).where(rates: { kind: 'pickup' }).order(date: :desc) }
  scope :sort_by_date, -> { order('date ASC') }

  scope :filter_between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }

  # ! pgsearch search in text fields
  # pg_search_scope :filter_by_rate, against: :rate_name
  # pg_search_scope :filter_by_product, associated_against: {
  #  customer: %i[name]
  # }

  def validate_code
    CodeGenerator.new(self).validate_code
  end
end
