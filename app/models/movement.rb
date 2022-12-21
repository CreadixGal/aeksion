class Movement < ApplicationRecord
  include PgSearch::Model

  belongs_to :rate, inverse_of: :movements

  has_many :product_movements
  has_many :products, through: :product_movements, dependent: :destroy

  has_one :customer, through: :rate

  validates :date, presence: true

  delegate :name, :price, to: :rate, prefix: :rate
  delegate :name, to: :customer, prefix: :customer
  delegate :amount, to: :product_movements
  accepts_nested_attributes_for :product_movements

  scope :delivery, -> { joins(:rate).where(rates: { kind: 'delivery' }) }
  scope :pickup, -> { joins(:rate).where(rates: { kind: 'pickup' }) }
  scope :sort_by_date, -> { order('date ASC') }

  # ! SEARCH BETWEEN DATES
  scope :filter_between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }

  # ! pgsearch busqueda por campos de texto
  # pg_search_scope :filter_by_rate, against: :rate_name
  pg_search_scope :filter_by_product, associated_against: {
    customer: %i[name]
  }
end
