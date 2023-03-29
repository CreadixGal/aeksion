class StockControl
  attr_reader :resource, :product, :movement

  def initialize(product_movement)
    @resource = product_movement
    @product  = product_movement.product
    @movement = product_movement.movement
  end

  def enough_stock?
    return true if movement.rate_pickup? || resource.return?

    resource.quantity <= product.stock
  end

  # for create action
  # update stock of product with the value assigned for quantity of product movement
  def update_stock
    return false unless enough_stock?

    product.increment(:stock, resource.quantity) if movement.rate_pickup?
    product.decrement(:stock, resource.quantity) if movement.rate_delivery?
    new_amount(movement.rate_kind)
    product.save!
  end

  # for update action
  # first need restore stock of product
  # to previous value after product movement created
  def restore_stock
    product.increment(:stock, resource.quantity) if movement.rate_delivery?
    product.decrement(:stock, resource.quantity) if movement.rate_pickup?
    new_amount(movement.rate_kind)
    product.save!
  end

  # then update stock of product with the new value for quantity of product movement
  def update_stock!
    restore_stock
    update_stock unless resource.return?
  end

  # update amount of movement
  def new_amount(kind)
    price = @product.variants.find_by(zone_id: @movement.rate.zone_id).quantity if kind.eql?('pickup')
    price = @movement.rate.zone.quantity if kind.eql?('delivery')
    # TODO: hacia los calculos pero rompia, al ponerlo a 0 no rompe pero los calculos son 0
    price = 0 if price.nil?
    resource.amount = price * resource.quantity
    resource.save!
  end
end
