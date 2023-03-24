class ProductMovement < ApplicationRecord
  belongs_to :movement
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  has_one :price, as: :priciable

  private

  def update_amount
    calculate_amount(movement.rate.customer.price.quantity) if movement.rate.pickup?
    calculate_amount(movement.rate.zone.price.quantity) if movement.rate.delivery?
  end

  def calculate_amount(price)
    update! amount: price * quantity
  end

  # validate :enough_stock, on: %i[create update], if: -> { movement.rate.kind == 'delivery' }
  after_create :calculate_stock

  def return!
    update!(return: true) unless return?
  end

  def enough_stock
    return true if StockControl.new(self).enough_stock?

    errors.add(:quantity, 'no hay suficiente stock')
  end

  def calculate_stock
    StockControl.new(self).update_stock
  end

  def recalculate_stock
    StockControl.new(self).update_stock!
  end
end
