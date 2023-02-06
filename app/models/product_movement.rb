class ProductMovement < ApplicationRecord
  belongs_to :movement, inverse_of: :product_movements
  belongs_to :product, inverse_of: :product_movements

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  validate :enough_stock, on: %i[create update], if: -> { movement.rate.kind == 'delivery' }
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
