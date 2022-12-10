# rubocop:disable Rails/SkipsModelValidations
class Api::V1::MovementsController < Api::V1::BaseController
  before_action :set_movement, only: %i[show update destroy]
  def index
    movements = Movement.all
    json_render(movements)
  end

  def show
    json_render(@movement)
  end

  def create
    movement = Movement.create!(movement_params)
    json_render(movement)
  end

  def create_bulk
    movements = params[:movements].map do |movement|
      {
        rate_id: movement[:rate_id],
        date: movement[:date]
      }
    end

    Movement.upsert_all(movements)

    json_render(movements)
  end

  def update
    @movement.update!(movement_params)
    json_render(@movement)
  end

  def update_bulk
    movements = params[:movements].map do |movement|
      {
        id: movement[:id],
        rate_id: movement[:rate_id],
        date: movement[:date]
      }
    end

    Movement.upsert_all(movements, unique_by: :id)

    json_render(movements)
  end

  def destroy
    movement = Movement.find(params[:movements][0][:id])
    movement.product_movements.destroy! if movement.product_movements.present?
    movement.destroy!
  end

  private

  def set_movement
    @movement = Movement.find(params[:id])
  end

  def movement_params
    params.require(:movements).permit(:rate_id, :date)
  end
end

# rubocop:enable Rails/SkipsModelValidations
