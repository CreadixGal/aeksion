class MovementsController < ApplicationController
  before_action :set_movement, only: %i[show edit update destroy update_status mark_all_return]
  before_action :set_kind_person, only: :export_pdf
  add_breadcrumb 'Flujos', ''

  def index
    add_breadcrumb t(".#{params[:kind]}") if params[:kind].present?
    @movements = filter(params)
    @pagy, @movements = pagy(@movements)
  end

  def filter(params)
    @movements = Movement.by_kind(params[:kind])

    if params[:range].present?
      range = params[:range].include?('a') ? params[:range].split('a') : [params[:range], params[:range]]
      start_date, end_date = range.map(&:to_date)
      @movements = @movements.between_dates(start_date.beginning_of_day, end_date.end_of_day)
    end
    @movements = @movements.by_product_kind(params[:product_kind]) if params[:product_kind].present?
    @movements = @movements.by_product_name(params[:product_ids]) if params[:product_ids].present?
    @movements
  end

  def product_searcher
    @items = Product.where(kind: 'box')
    @items = Product.where(kind: 'pallet') if params[:product_kind] == 'pallet'
  end

  def search
    text_fragment = params[:name]

    movements = Movement.by_kind(params[:kind])

    unless movements.empty?
      if params[:kind].eql?('delivery')
        movements = movements.joins(:customer)
                             .where('customers.name ILIKE ?', "%#{text_fragment}%")
                             .or(movements.joins(:customer).where('movements.code ILIKE ?', "%#{text_fragment}%"))
      end

      if params[:kind].eql?('pickup')
        movements = movements.joins(rate: :delivery_rider)
                             .where('delivery_riders.name ILIKE ?', "%#{text_fragment}%")
                             .or(movements.joins(rate: :delivery_rider).where('movements.code ILIKE ?', "%#{text_fragment}%"))
      end
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
        format.html { redirect_to movements_path(kind: params[:kind]), success: t('.success') }
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
      format.html { redirect_to movements_path(kind: params[:kind]), success: t('.success') }
      format.turbo_stream
    end
  end

  def multiple_delete
    if params[:movement_ids].present?
      ids = params[:movement_ids]
      ids.compact_blank!.each do |id|
        movement = Movement.joins(:product_movements).find_by(id:)
        next if movement.blank?

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
    @rates = Rate.joins(:zone).where(zones: { name: [Zone.pluck(:name)] }, kind: 'delivery') if params[:kind].eql?('delivery')
    @rates = Rate.where(zone_id: params[:id], kind: 'pickup') if params[:kind].eql?('pickup')
    @products = Variant.where(zone_id: params[:id])
    rates_options = view_context.options_from_collection_for_select(@rates, :id, :name, params[:selected])
    products_options = view_context.options_from_collection_for_select(@products, :id, :code)

    respond_to do |format|
      format.json { render json: { rates: rates_options, products: products_options } }
    end
  end

  def export_pdf
    @all_movements = filter(params)
    pdf = Prawn::Document.new
    table_data = Array.new
    table_data << ["Sumatorio: XXX"]
    table_data << ["Código", "Fecha", "Zona", @kind, "Total"]
    @all_movements.each do |movement|
      table_data << [movement.code, movement.date.strftime('%d/%m/%Y').to_s, movement.rate&.zone&.name, @kind == "Cliente" ? movement.rate&.customer&.name : movement.rate&.delivery_rider&.name, movement.amount]
    end

    pdf.table(table_data) do |table|

      table.column(0).align = :center
      table.column(1).align = :center
      table.column(2).align = :center
      table.column(3).align = :center
      table.column(4).align = :center

      #table.row(0).font_style = :bold
      #table.row(0).background_color = 'DDDDDD'
      table.row(0).width = 100
      table.row(1).font_style = :bold
      table.row(1).background_color = 'DDDDDD'

      table.cells.border_width = 0.5

      table.cells.width = 100
    end

    send_data pdf.render, filename: 'test.pdf', type: 'application/pdf', disposition: 'inline'
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

  def set_kind_person
    @kind = params[:kind] == "delivery" ? "Cliente" : "Repartidor"
  end
end
