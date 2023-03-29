class Movement < ApplicationRecord
  include PgSearch::Model

  belongs_to :rate, inverse_of: :movements

  has_many :product_movements, dependent: :destroy
  accepts_nested_attributes_for :product_movements,
                                allow_destroy: true,
                                reject_if: proc { |attr| attr['product_id'].blank? }
  has_many :products, through: :product_movements, dependent: :destroy

  has_one :customer, through: :rate

  delegate :name, :kind, :delivery?, :pickup?, to: :rate, prefix: :rate
  delegate :name, to: :customer, prefix: :customer
  delegate :amount, to: :product_movements

  validates :date, presence: true

  # rubocop:disable  Layout/LineLength
  scope :delivery, -> { includes(%i[rate product_movements]).where(rates: { kind: 'delivery' }, product_movements: { return: false }).order(date: :desc) }
  # rubocop:enable  Layout/LineLength
  scope :pickup, -> { includes(%i[rate product_movements]).where(rates: { kind: 'pickup' }).order(date: :desc) }
  scope :return, -> { includes(%i[product_movements]).where(product_movements: { return: true }).order(date: :desc) }
  scope :sort_by_date, -> { order('date ASC') }

  scope :between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }
  scope :by_product_kind, ->(kind) { joins(:products).where(products: { kind: }) }
  scope :by_product_code, ->(code) { joins(:products).where(products: { code: }) }

  enum status: { progress: 0, finished: 1 }

  # ! pgsearch search in text fields
  # pg_search_scope :filter_by_rate, against: :rate_name
  # pg_search_scope :filter_by_product, associated_against: {
  #  customer: %i[name]
  # }

  def returned?
    product_movements.any?(&:return)
  end

  def amount
    product_movements.sum(&:amount)
  rescue StandardError
    0
  end

  private

  def set_rate
    rate = Rate.where(customer_id: custormer.id, zone_id: zone.id)
    return if rate.nil?

    update!(rate:)
  end

  def any_blank(attributes)
    attributes['product_id'].blank? || attributes['quantity'].blank?
  end
end
