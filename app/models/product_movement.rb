class ProductMovement < ApplicationRecord
  belongs_to :movement, inverse_of: :product_movements
  belongs_to :product, inverse_of: :product_movements

  validate :enough_stock, on: %i[create update], if: -> { movement.rate.kind == 'delivery' }

  after_create :recalculate_stock, :update_amount

  private

  def update_amount
    calculate_amount(movement.rate.customer.price.quantity) if movement.rate.pickup?
    calculate_amount(movement.rate.zone.price.quantity) if movement.rate.delivery?
  end

  def calculate_amount(price)
    update! amount: price * quantity
  end

  def enough_stock
    return unless product && quantity > product.stock

    errors.add(:quantity,
               'el stock del producto es insuficiente para crear este movimiento')
  end

  def recalculate_stock
    kind = movement.rate.kind
    add_stock_to_product if kind.eql?('pickup')
    substract_stock_to_product if kind.eql?('delivery')
  end

  # rubocop:disable Rails/SkipsModelValidations
  def add_stock_to_product
    product = Product.find(product_id)
    product.increment!(:stock, quantity)
  end

  def substract_stock_to_product
    product = Product.find(product_id)
    product.decrement!(:stock, quantity)
  end
  # rubocop:enable Rails/SkipsModelValidations
end
