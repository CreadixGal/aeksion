class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]

  def index
    @movements = movements(params[:kind])

    @movements = filter_by(params)
    if params[:range].present?
      start_date, end_date = params[:range].split('a')
      @movements = @movements.filter_between_dates(start_date, end_date)
    end
    @pagy, @movements = pagy(@movements)
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

  def edit; end

  def create
    @movement = Movement.new(movement_params)

    respond_to do |format|
      if @movement.save
        format.html { redirect_to movements_path(kind: @movement.rate_kind), success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:error] = t('.error') }
      end
    end
  end

  def update
    respond_to do |format|
      if @movement.update(movement_params)
        format.html { redirect_to movements_path(kind: @movement.rate_kind), success: t('.success') }
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
      format.html { redirect_to movements_path(kind: params[:kind]) }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def multiple_delete
    if params[:movement_ids].present?

      Movement.where(id: params[:movement_ids].compact).destroy_all
      respond_to do |format|
        format.html { redirect_to movements_path(kind: params[:kind]), success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    else
      respond_to do |format|
        format.html { redirect_to movements_path(params[:kind]), error: t('.alert') }
        format.turbo_stream { flash.now[:error] = t('.alert') }
      end
    end
  end

  private

  def movement_params
    params.require(:movement).permit(:rate_id, :code, :date, product_movements_attributes: %i[product_id quantity])
  end

  def set_movement
    @movement = Movement.find(params[:id])
  end
end
