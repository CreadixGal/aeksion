class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]

  def index
    @movements = Movement.includes(%i[rate customer]).all
    @movements = Movement.includes(%i[rate customer]).delivery if params[:kind] == 'delivery'
    @movements = Movement.includes(%i[rate customer]).pickup if params[:kind] == 'pickup'
    # @movements = filter_by(params)
    if params[:start_date].present? && params[:end_date].present?
      @movements = @movements.filter_between_dates(params[:start_date], params[:end_date])
    end
    @pagy, @movements = pagy(@movements, items: 10)
  end

  def search
    @customers = Movement.all.map(&:customer) if params[:kind].blank?
    @customers = Movement.delivery.map(&:customer) if params[:kind] == 'delivery'
    @customers = Movement.pickup.map(&:customer) if params[:kind] == 'pickup'
    text_fragment = params[:name]
    @filtered_customers = @customers.select { |e| e.name.upcase.include?(text_fragment.upcase) } if @customers.present?
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            'search_results',
            partial: 'movements/shared/search_results',
            locals: { customers: @filtered_customers }
          )
        ]
      end
    end
  end

  # def filter_by(params)
  #   movements.filter_by_customer(params[:customer]) if params[:customer_name].present?
  #   movements.filter_by_rate(params[:rate]) if params[:rate_name].present?
  #   movements.filter_by_product(params[:product]) if params[:product_code].present?
  # end
  
  def show; end

  def new
    @movement = Movement.new
  end

  def create
    @movement = Movement.new(movement_params)

    respond_to do |format|
      if @movement.save
        format.html { redirect_to movements_path, success: 'Movement was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Movement was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:error] = 'Movement was not created.' }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @movement.update(movement_params)
        format.html { redirect_to movements_path, success: 'Movement was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'Movement was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:error] = 'Movement was not updated.' }
      end
    end
  end

  def destroy
    @movement.destroy!

    respond_to do |format|
      format.html { redirect_to movements_path, alert: 'Movement was successfully destroyed.' }
      format.turbo_stream { flash.now[:alert] = 'Movement was successfully destroyed.' }
    end
  end

  def multiple_delete
    if params[:movement_ids].present?
      ids = params[:movement_ids].compact

      Movement.joins(:products).includes([:product_movements]).where(id: ids).destroy_all

      respond_to do |format|
        format.html do
          redirect_to movements_path(params[:kind]), alert: 'All selected Zone were successfully destroyed.'
        end
        format.json { head :no_content }
      end
    else
      flash.now[:error] = 'Please select at least one Zone.'
    end
  end

  private

  def movement_params
    params.require(:movement).permit(:rate_id, :date, product_movements_attributes: %i[product_id quantity])
  end

  def set_movement
    @movement = Movement.find(params[:id])
  end
end
