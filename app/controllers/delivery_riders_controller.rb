class DeliveryRidersController < ApplicationController
  before_action :set_delivery_rider, only: %i[show edit update destroy]
  before_action :set_price, only: %i[create]

  # GET /delivery_riders or /delivery_riders.json
  def index
    add_breadcrumb t('.breadcrumb'), ''
    @delivery_riders = DeliveryRider.ordered
    @pagy, @delivery_riders = pagy(@delivery_riders)
  end

  def search
    @delivery_riders = DeliveryRider.all
    text_fragment = params[:name]
    @filtered_delivery_riders = @delivery_riders.select { |e| e.name.upcase.include?(text_fragment.upcase) }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            'search_results',
            partial: 'delivery_riders/shared/search_results',
            locals: { delivery_riders: @filtered_delivery_riders }
          )
        ]
      end
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
  end

  # GET /delivery_riders/1/edit
  def edit; end

  # POST /delivery_riders or /delivery_riders.json
  def create
    @delivery_rider = DeliveryRider.new(delivery_rider_params.except(:price))

    respond_to do |format|
      if @delivery_rider.save
        Price.find(@delivery_rider.price.id).update!(quantity: delivery_rider_params[:price])
        @delivery_rider.reload
        format.html { redirect_to delivery_riders_path, success: 'DeliveryRider was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'DeliveryRider was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /delivery_riders/1 or /delivery_riders/1.json
  def update
    respond_to do |format|
      price = Price.find(@delivery_rider.price.id).update(quantity: delivery_rider_params[:price])
      if @delivery_rider.update(delivery_rider_params.except(:price)) && price
        @delivery_rider.reload
        format.html { redirect_to delivery_riders_path, success: 'DeliveryRider was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'DeliveryRider was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /delivery_riders/1 or /delivery_riders/1.json
  def destroy
    @delivery_rider.destroy!

    respond_to do |format|
      format.html { redirect_to delivery_riders_path, alert: 'DeliveryRider was successfully destroyed.' }
      format.turbo_stream { flash.now[:alert] = 'DeliveryRider was successfully destroyed.' }
    end
  end

  def multiple_delete
    if params[:delivery_rider_ids].present?
      DeliveryRider.where(id: params[:delivery_rider_ids].compact).destroy_all
      respond_to do |format|
        format.html { redirect_to delivery_riders_path, success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    else
      respond_to do |format|
        format.html { redirect_to delivery_riders_path, error: t('.alert') }
        format.turbo_stream { flash.now[:error] = t('.alert') }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_delivery_rider
    @delivery_rider = DeliveryRider.find(params[:id])
  end

  def set_price
    @price = params[:delivery_rider][:price]
  end

  # Only allow a list of trusted parameters through.
  def delivery_rider_params
    params.require(:delivery_rider).permit(:name, :price)
  end
end
