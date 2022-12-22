class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]

  def index
    @movements = movements(params[:kind])

    @movements = filter_by(params)
    if params[:start_date].present? && params[:end_date].present?
      @movements = @movements.filter_between_dates(params[:start_date], params[:end_date])
    end
    @pagy, @movements = pagy(@movements, items: 10) if @pagy.present?
  end

  def movements(kind)
    allowed_methods = %w[delivery pickup]
    Movement.send(kind) if allowed_methods.include?(kind)
  end

  def filter_by(params)
    @movements = movements(params[:kind])
    return @movements if params[:product_kind].blank?

    @movements = @movements.joins(:products)
                           .where(products: { kind: params[:product_kind] })
  end

  def search
    @movements = movements(params[:kind])
    text_fragment = params[:name]
    unless @movements.empty?
      @filtered_movements = @movements.select do |e|
        customer = e.attributes.merge(customer_name: e.customer.name.upcase)
        customer[:customer_name].include?(text_fragment.upcase)
      end
    end
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            'search_results',
            partial: 'movements/shared/search_results',
            locals: { movements: @filtered_movements.presence || [] }
          )
        ]
      end
    end
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
