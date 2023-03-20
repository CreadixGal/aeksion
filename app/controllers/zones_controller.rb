class ZonesController < ApplicationController
  before_action :set_zone, only: %i[show edit update destroy]

  def index
    @zones = Zone.ordered
    @pagy, @zones = pagy(@zones)
  end

  def show; end

  def new
    @zone = Zone.new
  end

  def edit; end

  def create
    @zone = Zone.new(name: zone_params[:name])

    @zone.price = Price.new(quantity: zone_params[:price])

    respond_to do |format|
      if @zone.save
        format.html { redirect_to zones_path, success: 'Zone was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Zone was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      price = Price.find(@zone.price.id)
      if @zone.update(name: zone_params[:name]) && price.update(quantity: zone_params[:price])
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
    params.require(:zone).permit(:name, :price)
  end

  def set_zone
    @zone = Zone.find(params[:id])
  end
end
