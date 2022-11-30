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

  def bulk_update
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
