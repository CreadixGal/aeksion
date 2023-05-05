class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy update_status mark_all_return]

  def index
    @movements = filter(params)
    @pagy, @movements = pagy(@movements)
    respond_to do |format|
      format.html
      format.json
      format.pdf {render template: 'movements/reporte', pdf: 'Reporte'}
    end
  end

  def movements(kind)
    if kind.eql?('pickup')
      Movement.preload([{ variants: %i[product price] }, { product_movements: :variant }]).send(kind)
    else
      Movement.preload([{ variants: [:product] }, { product_movements: :variant }]).send(kind)
    end
  end

  def filter(params)
    @movements = movements(params[:kind])

    if params[:range].present?
      range = params[:range].include?('a') ? params[:range].split('a') : [params[:range], params[:range]]
      start_date, end_date = range.map(&:to_date)
      @movements = @movements.between_dates(start_date.beginning_of_day, end_date.end_of_day)
    end
    @movements = @movements.by_product_kind(params[:product_kind]) if params[:product_kind].present?
    @movements = @movements.by_product_code(params[:product_ids]) if params[:product_ids].present?
    @movements
  end

  def product_searcher
    @items = Product.where(kind: 'box')
    @items = Product.where(kind: 'pallet') if params[:product_kind] == 'pallet'
  end

  def search
    text_fragment = params[:name]

    movements = movements(params[:kind])
    unless movements.empty?
      movements =  movements.joins(:customer)
                            .where('customers.name ILIKE ?', "%#{text_fragment}%")
                            .or(movements.where('movements.code ILIKE ?', "%#{text_fragment}%"))
    end
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
    @zones = Zone.all
    @variants_by_zone = Variant.all
  end

  def edit; end

  def create
    @movement = Movement.new(movement_params.except(:customer_id, :zone_id))
    @movement.product_movements.each { |pm| StockControl.new(pm).new_amount }

    respond_to do |format|
      if @movement.save
        @movement.reload
        format.html { redirect_to movements_path(kind: 'pickup'), success: t('.success') }
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
        format.turbo_stream { flash.now[:error] = @movement.errors.full_messages.join(', ') }
      end
    end
  end

  def destroy
    @movement.product_movements.each do |pm|
      StockControl.new(pm).restore_stock
    end
    @movement.destroy!
    respond_to do |format|
      format.html { redirect_to movements_path(kind: params[:kind]) }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def multiple_delete
    if params[:movement_ids].present?
      ids = params[:movement_ids]
      ids.each do |id|
        movement = Movement.joins(:product_movements).find(id)
        movement.product_movements.each do |pm|
          StockControl.new(pm).restore_stock
        end
        movement.destroy!
      end

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

  def update_status
    @movement.finished! if @movement.progress?
    redirect_to movements_path(kind: @movement.rate_kind)
    flash.now[:success] = t('.success')
  end

  def mark_as_return
    product_movement = ProductMovement.find(params[:product_movement_id])
    product_movement.return!
    product_movement.recalculate_stock
    flash.now[:success] = t('.success')
    redirect_to movements_path(kind: 'return')
  end

  def mark_all_return
    @movement.product_movements.each(&:return!)
    @movement.product_movements.each(&:recalculate_stock)
    flash.now[:success] = t('.success')
    redirect_to movements_path(kind: 'return')
  end

  def fetch_form
    @rates = []
    @rates = Rate.joins(:zone).where(zones: {name: 'Product'}, kind: 'pickup') if params[:kind].eql?('pickup')
    @rates = Rate.where(zone_id: params[:id], kind: 'delivery') if params[:kind].eql?('delivery')
    @products = Variant.where(zone_id: params[:id])
    rates_options = view_context.options_from_collection_for_select(@rates, :id, :name, params[:selected])
    products_options = view_context.options_from_collection_for_select(@products, :id, :code)

    respond_to do |format|
      format.json { render json: { rates: rates_options, products: products_options } }
    end
  end

  private

  def movement_params
    params.require(:movement).permit(
      :id,
      :status,
      :rate_id,
      :zone_id,
      :code,
      :date,
      product_movements_attributes: %i[_destroy id product_id variant_id zone_id quantity]
    )
  end

  def set_movement
    @movement = Movement.find(params[:id])
  end
end
