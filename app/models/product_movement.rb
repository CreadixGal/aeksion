class ProductMovement < ApplicationRecord
  belongs_to :movement
  belongs_to :product

  validate :enough_stock, on: %i[create update], if: -> { movement.rate.kind == 'delivery' }

  after_create :recalculate_stock, :update_amount

  private

  def update_amount
    update! amount: movement.rate.price * quantity
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
