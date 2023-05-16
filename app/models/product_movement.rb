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
  after_create :calculate_amount

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

  def calculate_amount
    result = 0
    # ! -> pickup must be multiplied by the (price)quantity of the variant(by zone)
    # ! -> f.e if the variant price is 0.013 and the quantity(stock/units) is 100 the amount will be 1.3
    if movement.rate_pickup?
      price = variant.quantity
      result = price * quantity
    end
    # ! -> delivery must calculate over the (price)quantity of the customer(by zone) independent of the stock/units
    # ! -> f.e if the price of the customer is 500 and the quantity(stock/units) is 100 the amount will be 500
    # ! -> in this case ignore the stock/units of the product movement
    result = movement.rate.quantity if movement.rate_delivery?

    update! amount: result
  end

  def enough_stock
    return true if movement.rate_pickup?
    return true if StockControl.new(self).enough_stock?

    errors.add(:quantity, 'no hay suficiente stock')
    false
  end
end
