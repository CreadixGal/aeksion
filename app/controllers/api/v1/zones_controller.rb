# rubocop:disable Rails/SkipsModelValidations

class Api::V1::ZonesController < Api::V1::BaseController
  before_action :set_zone, only: %i[show update destroy]

  def index
    zones = Zone.all
    json_render(zones)
  end

  def show
    json_render(@zone)
  end

  def create
    zone = Zone.create!(zone_params)
    json_render(zone)
  end

  def create_bulk
    zones = params[:zones].map do |zone|
      {
        name: zone[:name]
      }
    end

    Zone.upsert_all(zones)

    json_render(zones)
  end

  def update
    @zone.update!(zone_params)
    json_render(@zone)
  end

  def update_bulk
    zones = params[:zones].map do |zone|
      {
        id: zone[:id],
        name: zone[:name]
      }
    end

    Zone.upsert_all(zones, unique_by: :id, update_only: [:name])

    json_render(zones)
  end

  def destroy
    zone = Zone.find(params[:zones][0][:id])
    zone.rates.destroy! if zone.rates.present?
    zone.destroy!
  end

  private

  def set_zone
    @zone = Zone.find(params[:id])
  end

  def zone_params
    params.require(:zones).permit(:name)
  end
end

# rubocop:enable Rails/SkipsModelValidations
