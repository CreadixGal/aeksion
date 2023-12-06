class ZonesController < ApplicationController
  before_action :set_zone, only: %i[show edit update destroy]
  add_breadcrumb 'Zonas', ''

  def index
    @zones = Zone.ordered
    @headers = %w[name price]
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
    respond_to do |format|
      if @zone.used?
        flash.now[:error] = t('.used')
      else
        @zone.destroy!
        flash.now[:success] = t('.success')
      end

      format.html { redirect_to zones_path }
      format.turbo_stream
    end
  end

  def multiple_delete
    respond_to do |format|
      if params[:zone_ids].present?
        Zone.includes(%i[variants rates customers])
            .where(id: params[:zone_ids].compact)
            .destroy_all
        flash.now[:success] = t('.success')
      else
        flash.now[:error] = t('.alert')
      end
    rescue ActiveRecord::InvalidForeignKey
      flash.now[:error] = t('.used')
    ensure
      format.html { redirect_to zones_path }
      format.turbo_stream
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
