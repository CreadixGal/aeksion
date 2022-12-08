# rubocop:disable Rails/SkipsModelValidations

class Api::V1::RatesController < Api::V1::BaseController
  def index
    rates = Rate.all
    json_render(rates)
  end

  def show
    rate = Rate.find(params[:id])
    json_render(rate)
  end

  def create
    customer_id = params[:rates][0][:customer_id]
    zone_id = params[:rates][0][:zone_id]
    kind = params[:rates][0][:kind]
    price = params[:rates][0][:price]
    rate = Rate.create(customer_id: customer_id, zone_id: zone_id, kind: kind, price: price)
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
end

# rubocop:enable Rails/SkipsModelValidations
