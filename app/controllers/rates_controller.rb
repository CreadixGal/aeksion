class RatesController < ApplicationController
  before_action :set_rate, except: %i[index new create multiple_delete fetch_form]

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
    Rails.logger.info "params -> #{params.inspect}"
    # render plain: params.inspect
    @rate = Rate.new(rate_params.except(:price))
    @rate.price = Price.new(quantity: rate_params[:price])

    respond_to do |format|
      if @rate.save
        Rails.logger.info "\n\n #{@rate.price.quantity}"
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
