# rubocop:disable Rails/SkipsModelValidations

class Api::V1::ProductMovementsController < Api::V1::BaseController
  def index
    product_movements = ProductMovement.all
    json_render(product_movements)
  end

  def show
    product_movement = ProductMovement.find(params[:id])
    json_render(product_movement)
  end

  def create
    movement_id = params[:product_movements][0][:movement_id]
    product_id = params[:product_movements][0][:product_id]
    quantity = params[:product_movements][0][:quantity]
    product_movement = ProductMovement.create(movement_id: movement_id, product_id: product_id, quantity: quantity)
    json_render(product_movement)
  end

  def create_bulk
    product_movements = params[:product_movements].map do |product_movement|
      {
        movement_id: product_movement[:movement_id],
        product_id: product_movement[:product_id],
        quantity: product_movement[:quantity]
      }
    end

    ProductMovement.upsert_all(product_movements)

    json_render(product_movements)
  end

  def update
    product_movement = ProductMovement.find(params[:id])
    product_movement.update(
      movement_id: params[:product_movement][0][:movement_id],
      product_id: params[:product_movement][0][:product_id],
      quantity: params[:product_movement][0][:quantity]
    )
    json_render(product_movement)
  end

  def update_bulk
    product_movements = params[:product_movements].map do |product_movement|
      {
        id: product_movement[:id],
        movement_id: product_movement[:movement_id],
        product_id: product_movement[:product_id],
        quantity: product_movement[:quantity]
      }
    end

    ProductMovement.upsert_all(product_movements, unique_by: :id)

    json_render(product_movements)
  end

  def destroy
    product_movement = ProductMovement.find(params[:product_movements][0][:id])
    product_movement.destroy!
  end
end

# rubocop:enable Rails/SkipsModelValidations
