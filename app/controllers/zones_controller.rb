class ZonesController < ApplicationController
  before_action :set_zone, only: %i[show edit update destroy]

  def index
    @zones = Zone.ordered
    @pagy, @zones = pagy(@zones, items: 10)
  end

  def show; end

  def new
    @zone = Zone.new
  end

  def create
    @zone = Zone.new(zone_params)

    respond_to do |format|
      if @zone.save
        format.html { redirect_to zones_path, success: 'Zone was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Zone was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @zone.update(zone_params)
        format.html { redirect_to zones_path, success: 'Zone was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'Zone was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @zone.destroy!

    respond_to do |format|
      format.html { redirect_to zones_path, alert: 'Zone was successfully destroyed.' }
      format.turbo_stream { flash.now[:alert] = 'Zone was successfully destroyed.' }
    end
  end

  def multiple_delete
    if params[:zone_ids].present?

      Zone.where(id: params[:zone_ids].compact).destroy_all
      respond_to do |format|
        format.html { redirect_to zones_path, success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    else
      respond_to do |format|
        format.html { redirect_to zones_path, error: t('.alert') }
        format.turbo_stream { flash.now[:error] = t('.alert') }
      end
    end
  end

  private

  def zone_params
    params.require(:zone).permit(:name)
  end

  def set_zone
    @zone = Zone.find(params[:id])
  end
end
