class DeliveryRidersController < ApplicationController
  before_action :set_delivery_rider, only: %i[show edit update destroy]

  # GET /delivery_riders or /delivery_riders.json
  def index
    add_breadcrumb t('.breadcrumb'), ''
    @headers = %w[name price]
    delivery_riders = DeliveryRider.ordered
    @pagy, @delivery_riders = pagy(delivery_riders)
  end

  # POST /admin/contact/search
  def search
    scope = params[:name].blank? ? DeliveryRider.ordered : DeliveryRider.all.filter_by_text(params[:name])
    @pagy, @delivery_riders = pagy(scope, items: 10)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  # GET /delivery_riders/1 or /delivery_riders/1.json
  def show
    add_breadcrumb t('.breadcrumb'), delivery_riders_path
    add_breadcrumb @delivery_rider.name, delivery_rider_path(@delivery_rider)
  end

  # GET /delivery_riders/new
  def new
    @delivery_rider = DeliveryRider.new
    @delivery_rider.build_price unless @delivery_rider.price
  end

  # GET /delivery_riders/1/edit
  def edit
    @delivery_rider.build_price unless @delivery_rider.price
  end

  # POST /delivery_riders or /delivery_riders.json
  def create
    @delivery_rider = DeliveryRider.new(delivery_rider_params)

    respond_to do |format|
      if @delivery_rider.save
        flash.now[:success] = t('.success')
        format.html { redirect_to delivery_riders_path }
        format.turbo_stream
      else
        flash.now[:error] = t('.error')
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_riders/1 or /delivery_riders/1.json
  def update
    respond_to do |format|
      if @delivery_rider.update(delivery_rider_params)
        flash.now[:success] = t('.success')
        format.html { redirect_to delivery_riders_path }
        format.turbo_stream
      else
        flash.now[:error] = t('.error')
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_riders/1 or /delivery_riders/1.json
  def destroy
    @delivery_rider.destroy!

    respond_to do |format|
      flash.now[:success] = t('.success')
      format.html { redirect_to delivery_riders_path }
      format.turbo_stream
    end
  end

  def multiple_delete
    respond_to do |format|
      if params[:delivery_rider_ids].present?
        DeliveryRider.where(id: params[:delivery_rider_ids].compact).destroy_all
        flash.now[:success] = t('.success')
      else
        flash.now[:error] = t('.alert')
      end
    ensure
      format.html { redirect_to delivery_riders_path }
      format.turbo_stream
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery_rider
    @delivery_rider = DeliveryRider.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def delivery_rider_params
    params.require(:delivery_rider)
          .permit(:name, price_attributes: %i[id quantity])
  end
end
