class Movement < ApplicationRecord
  belongs_to :rate

  has_many :product_movements
  has_many :products, through: :product_movements, dependent: :destroy

  delegate :name, :price, :customer_name, to: :rate, prefix: :rate

  accepts_nested_attributes_for :product_movements

  before_create :run_code

  validates :rate_id, :date, presence: true
  validates :code, uniqueness: true

  scope :delivery, -> { joins(:rate).where(rates: { kind: 'delivery' }) }
  scope :pickup, -> { joins(:rate).where(rates: { kind: 'pickup' }) }
  
  # rubocop:disable Lint/SafeNavigationChain
  def run_code
    code = Movement.delivery&.order(created_at: :asc).last&.code if rate.delivery?
    code = Movement.pickup&.order(created_at: :asc).last&.code   if rate.pickup?
    code = code.nil? ? 0 : code
    self.code = generate_code(code)
  end
  # rubocop:enable Lint/SafeNavigationChain
  
  def generate_code(last_code)
    rate_code = rate.kind.slice(0..1).upcase
    year = Time.zone.now.year.to_s.last(2)
    code = last_code.to_s.slice(5, 7).to_i + 1
    self.code = "#{rate_code}#{year}-#{code.to_s.rjust(7,'0')}"
  end
end
