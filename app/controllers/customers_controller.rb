class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  # GET /customers or /customers.json
  def index
    add_breadcrumb t('.breadcrumb'), ''
    @headers = %w[name price]
    customers = Customer.ordered
    customers = search(params[:name]) if params[:name].present?
    @pagy, @customers = pagy(customers)
  end

  # POST /customers/search
  def search
    @headers = %w[name price]
    customers = Customer.includes([:price]).where('name ILIKE ?', "%#{params[:name]}%")
    @pagy, @customers = pagy(customers)

    respond_to(&:turbo_stream)
  end

  # GET /customers/1 or /customers/1.json
  def show
    add_breadcrumb t('.breadcrumb'), customers_path
    add_breadcrumb @customer.name.capitalize, customer_path(@customer)
    @total_movements = @customer.rates.sum { |rate| rate.movements.count }
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @customer.build_price unless @customer.price
  end

  # GET /customers/1/edit
  def edit
    @customer.build_price unless @customer.price
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        flash.now[:success] = t('.success')
        format.html { redirect_to customers_path }
        format.turbo_stream
      else
        flash.now[:error] = t('.error')
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        flash.now[:success] = t('.success')
        format.html { redirect_to customers_path }
        format.turbo_stream
      else
        flash.now[:error] = t('.error')
        format.html { render :edit }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy!

    respond_to do |format|
      format.html { redirect_to customers_path, success: t('.success') }
      format.turbo_stream { flash.now[:success] = t('.success') }
    end
  end

  def multiple_delete
    if params[:customer_ids].present?
      Customer.where(id: params[:customer_ids].compact).destroy_all
      respond_to do |format|
        format.html { redirect_to customers_path, success: t('.success') }
        format.turbo_stream { flash.now[:success] = t('.success') }
      end
    else
      respond_to do |format|
        format.html { redirect_to customers_path, error: t('.alert') }
        format.turbo_stream { flash.now[:error] = t('.alert') }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def customer_params
    params.require(:customer)
          .permit(:name, price_attributes: %i[id quantity])
  end
end
