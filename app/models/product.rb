class Product < ApplicationRecord
  has_one_attached :image
  has_many :variants, dependent: :destroy
  accepts_nested_attributes_for :variants, allow_destroy: true

  after_create :create_default_variant

  validates :stock, :kind, presence: true
  validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'El stock no puede ser negativo' }

  enum :kind, { pallet: 1, box: 2 }, field: { type: Integer, default: 1 }, map: :string, source: :kind

  private

  def create_default_variant
    zone = Zone.find_by(name: 'DEFAULT')
    variant = variants.build(
      code: name,
      zone:,
      price: Price.new(quantity: 0)
    )
    Rails.logger.info "Variant: #{variant.inspect}"
    variant.save!
  end
end
