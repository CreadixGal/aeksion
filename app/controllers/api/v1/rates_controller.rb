# rubocop:disable Rails/SkipsModelValidations

class Api::V1::RatesController < Api::V1::BaseController
  before_action :set_rate, only: %i[show update destroy]

  def index
    rates = Rate.all
    json_render(rates)
  end

  def show
    json_render(@rate)
  end

  def create
    rate = Rate.create!(rate_params)
    json_render(rate)
  end

  def create_bulk
    rates = params[:rates].map do |rate|
      {
        customer_id: rate[:customer_id],
        zone_id: rate[:zone_id],
        kind: rate[:kind],
        price: rate[:price]
      }
    end

    Rate.upsert_all(rates)

    json_render(rates)
  end

  def update
    @rate.update!(rate_params)
    json_render(@rate)
  end

  def update_bulk
    rates = params[:rates].map do |rate|
      {
        id: rate[:id],
        customer_id: rate[:customer_id],
        zone_id: rate[:zone_id],
        kind: rate[:kind],
        price: rate[:price]
      }
    end

    Rate.upsert_all(rates, unique_by: :id)

    json_render(rates)
  end

  def destroy
    rate = Rate.find(params[:rates][0][:id])
    rate.movements.destroy! if rate.movements.present?
    rate.destroy!
  end

  private

  def set_rate
    @rate = Rate.find(params[:id])
  end

  def rate_params
    params.require(:rates).permit(:customer_id, :zone_id, :kind, :price)
  end
end

# rubocop:enable Rails/SkipsModelValidations
