class ProductMovement < ApplicationRecord
  belongs_to :movement
  belongs_to :variant

  validates :quantity,
            presence: {
              message: "can't be blank"
            },
            numericality: {
              greater_than: 0,
              message: 'must be greater than 0'
            }

  has_one :price, as: :priciable

  validate :enough_stock, on: %i[create update]
  after_create :calculate_stock
  after_create :update_amount

  def return!
    update!(return: true) unless return?
  end

  def calculate_stock
    StockControl.new(self).update_stock
  end

  def recalculate_stock
    StockControl.new(self).update_stock!
  end

  private

  def update_amount
    if movement.rate.pickup?
      calculate_amount(variant.quantity)
    elsif movement.rate_delivery?
      calculate_amount(movement.rate.zone.quantity) if movement.rate.delivery?
    else
      update! amount: 0
    end
  end

  def calculate_amount(price)
    update! amount: (price * quantity)
  end

  def enough_stock
    return true if movement.rate_pickup?
    return true if StockControl.new(self).enough_stock?

    errors.add(:quantity, 'no hay suficiente stock')
    false
  end
end
