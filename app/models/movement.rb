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

  before_create :run_code

  validates :date, presence: true
  validates :code, uniqueness: true

  scope :delivery, -> { includes(%i[rate product_movements]).where(rates: { kind: 'delivery' }) }
  scope :pickup, -> { includes(%i[rate product_movements]).where(rates: { kind: 'pickup' }) }
  scope :sort_by_date, -> { order('date ASC') }

  scope :filter_between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }

  # ! pgsearch search in text fields
  # pg_search_scope :filter_by_rate, against: :rate_name
  # pg_search_scope :filter_by_product, associated_against: {
  #  customer: %i[name]
  # }

  def run_code
    data = delivery_code if rate.delivery?
    data = pickup_code   if rate.pickup?
    data = 0 if data.nil?
    self.code = generate_code(data)
  end

  # rubocop:disable Lint/SafeNavigationChain
  def delivery_code
    Movement.delivery&.order(created_at: :asc).last&.code
  end

  def pickup_code
    Movement.pickup&.order(created_at: :asc).last&.code
  end
  # rubocop:enable Lint/SafeNavigationChain

  def generate_code(last_code)
    rate_code = rate.kind.slice(0..1).upcase
    year = Time.zone.now.year.to_s.last(2)
    increment = last_code.to_s.slice(5, 7).to_i + 1
    "#{rate_code}#{year}-#{increment.to_s.rjust(7, '0')}"
  end
end
