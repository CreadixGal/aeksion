class RatesController < ApplicationController
  before_action :set_rate, except: %i[index new create multiple_delete fetch_form]
  add_breadcrumb 'Tarifas', ''

  def index
    # @rates = Rate.all
    @rates = Rate.delivery if params[:kind].eql?('delivery')
    @rates = Rate.pickup if params[:kind].eql?('pickup')
    @rates = Rate.return if params[:kind].eql?('return')
    @pagy, @rates = pagy(@rates)
  end

  def show; end

  def new
    Rails.logger.info "params[:kind]: #{params[:kind]}"
    @rate = Rate.new(kind: params[:kind])
  end

  def edit; end

  def create
    @rate = Rate.new(rate_params.except(:price))
    @rate.price = Price.new(quantity: rate_params[:price])
    @rate.customer.price = Price.update!(quantity: rate_params[:price]) if params[:kind].eql?('delivery')
    @rate.zone.price = Price.create!(quantity: rate_params[:price]) if params[:kind].eql?('pickup')
    respond_to do |format|
      if @rate.save
        format.html { redirect_to rates_path(kind: params[:kind]), success: 'Tarifa creada correctamente' }
        format.turbo_stream { flash.now[:success] = 'Tarifa creada correctamente' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @rate.update(rate_params.except(:price))
        @rate.customer.price.update!(quantity: rate_params[:price]) if @rate.delivery?
        if @rate.pickup? && @rate.zone.present?
          zone = @rate.zone
          zone.price.update!(quantity: rate_params[:price], priciable: zone) if @rate.zone.price.present?
          zone.price = Price.create!(quantity: rate_params[:price], priciable: zone) unless @rate.zone.price.present?
        end
        @rate.price.update!(quantity: rate_params[:price])
        format.html { redirect_to rates_path(kind: params[:kind]), success: 'Tarifa actualizada correctamente' }
        format.turbo_stream { flash.now[:success] = 'Tarifa actualizada correctamente' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @rate.destroy!
    respond_to do |format|
      format.html { redirect_to rates_path(kind: params[:kind]), alert: 'Tarifa eliminada correctamente' }
      format.turbo_stream { flash.now[:alert] = 'Tarifa eliminada correctamente' }
    end
  end

  def multiple_delete
    if params[:rate_ids].present?

      Rate.where(id: params[:rate_ids].compact).destroy_all
      respond_to do |format|
        format.html { redirect_to rates_path(kind: params[:kind]), success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    else
      respond_to do |format|
        format.html { redirect_to rates_path(kind: params[:kind]), error: t('.alert') }
        format.turbo_stream { flash.now[:error] = t('.alert') }
      end
    end
  end

  def enable
    respond_to do |format|
      if @rate.update!(enable: !@rate.enable)
        format.html { redirect_to rates_path(kind: params[:kind]), success: 'Tarifa actualizada correctamente' }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@rate, partial: 'rates/rate', locals: { rate: @rate })
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def rate_params
    params.require(:rate).permit(:customer_id, :zone_id, :kind, :name, :enable, :price)
  end

  def set_rate
    @rate = Rate.find(params[:id])
  end
end
