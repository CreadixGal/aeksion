class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]

  def index
    @movements = Movement.includes([:rate]).all
    @movements = Movement.includes([:rate]).delivery if params[:kind] == 'delivery'
    @movements = Movement.includes([:rate]).pickup if params[:kind] == 'pickup'
    @pagy, @movements = pagy(@movements, items: 10)
  end

  def show; end

  def new
    @movement = Movement.new
  end

  def create
    @movement = Movement.new(movement_params)

    respond_to do |format|
      if @movement.save
        format.html { redirect_to movements_path, success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:error] = t('.error') }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @movement.update(movement_params)
        format.html { redirect_to movements_path, success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:error] = t('.error') }
      end
    end
  end

  def destroy
    @movement.destroy!

    respond_to do |format|
      format.html { redirect_to movements_path, alert: t('.success') }
      format.turbo_stream { flash.now[:alert] = t('.success') }
    end
  end

  def multiple_delete
    if params[:movement_ids].present?
      ids = params[:movement_ids].compact

      Movement.includes(%i[product_movements products]).where(id: ids).destroy_all

      respond_to do |format|
        format.html do
          redirect_to movements_path(params[:kind]), alert: t('.success')
        end
        format.turbo_stream do
          redirect_to movements_path(params[:kind]), alert: t('.success')
        end
      end
    else
      flash.now[:alert] = t('.alert')
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
