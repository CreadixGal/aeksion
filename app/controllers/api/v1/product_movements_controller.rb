# rubocop:disable Rails/SkipsModelValidations

class Api::V1::ProductMovementsController < Api::V1::BaseController
  before_action :set_product_movement, only: %i[show update destroy]

  def index
    product_movements = ProductMovement.all
    json_render(product_movements)
  end

  def show
    json_render(@product_movement)
  end

  def create
    product_movement = ProductMovement.create!(product_movement_params)
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
    @product_movement.update!(product_movement_params)
    json_render(@product_movement)
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

  private

  def set_product_movement
    @product_movement = ProductMovement.find(params[:id])
  end

  def product_movement_params
    params.require(:product_movements).permit(:movement_id, :product_id, :quantity)
  end
end

# rubocop:enable Rails/SkipsModelValidations
