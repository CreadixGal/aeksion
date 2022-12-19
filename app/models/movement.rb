class Movement < ApplicationRecord
  belongs_to :rate

  has_many :product_movements
  has_many :products, through: :product_movements, dependent: :destroy

  delegate :name, :price, :customer_name, to: :rate, prefix: :rate

  accepts_nested_attributes_for :product_movements

  before_create :run_code

  scope :delivery, -> { joins(:rate).where(rates: { kind: 'delivery' }) }
  scope :pickup, -> { joins(:rate).where(rates: { kind: 'pickup' }) }

  def run_code
    code = rate.delivery? ? Movement.delivery&.order(created_at: :asc).last&.code : Movement.pickup&.order(created_at: :asc).last&.code
    code = code.nil? ? 0 : code
    self.code = generate_code(code)
  end

  def generate_code(last_code)
    code = last_code.to_s.slice(5, 7).to_i + 1
    self.code = "#{rate.kind.slice(0..1).upcase}#{Time.now.year.to_s.last(2)}-#{code.to_s.rjust(7,'0')}"
  end
end
