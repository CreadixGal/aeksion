# rubocop:disable Rails/SkipsModelValidations

class Api::V1::ZonesController < Api::V1::BaseController
  def index
    zones = Zone.all
    json_render(zones)
  end

  def show
    zone = Zone.find(params[:id])
    json_render(zone)
  end

  def create
    zones = params[:zones].map do |zone|
      {
        name: zone[:name]
      }
    end

    Zone.upsert_all(zones)

    json_render(zones)
  end

  def bulk_update
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
end

# rubocop:enable Rails/SkipsModelValidations
