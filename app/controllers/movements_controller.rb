class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy]

  def index
    @movements = filter_by(params)
    @pagy, @movements = pagy(@movements)
  end

  def movements(kind)
    allowed_methods = %w[delivery pickup]
    Movement.send(kind) if allowed_methods.include?(kind)
  end

  def filter_by(params)
    @movements = movements(params[:kind])

    if params[:range].present?
      start_date, end_date = params[:range].split('a')
      @movements = @movements.filter_between_dates(start_date, end_date)
    end

    if params[:product_kind].present?
      @movements = @movements.joins(:products)
                             .where(products: { kind: params[:product_kind] })
    end

    if params[:product_ids].present?
      @movements = @movements.joins(:products)
                             .where(products: { code: params[:product_ids] })
    end
    @movements
  end

  def product_searcher
    @items = Product.where(kind: 'box')
    @items = Product.where(kind: 'pallet') if params[:product_kind] == 'pallet'
  end

  def search
    text_fragment = params[:name]
    movements = movements(params[:kind])
    movements = movements.joins(:customer).where('customers.name ILIKE ?', "%#{text_fragment}%") unless movements.empty?
    @filtered_movements = movements

    @pagy, @filtered_movements = pagy(movements)

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

  def export_pdf
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "movements/export.html.erb"   # Excluding ".pdf" extension.
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
