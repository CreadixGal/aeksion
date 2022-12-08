# rubocop:disable Rails/SkipsModelValidations
class Api::V1::MovementsController < Api::V1::BaseController
  def index
    movements = Movement.all
    json_render(movements)
  end

  def show
    movement = Movement.find(params[:id])
    json_render(movement)
  end

  def create
    movement = Movement.create!(rate_id: params[:movements][0][:rate_id], date: params[:movements][0][:date])
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
    movement = Movement.find(params[:id])
    movement.update!(
      rate_id: params[:movement][0][:rate_id],
      date: params[:movement][0][:date]
    )
    json_render(movement)
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
end

# rubocop:enable Rails/SkipsModelValidations
