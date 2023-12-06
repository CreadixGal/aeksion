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

  def search(name)
    @customers = Customer.includes([:price]).where('name ILIKE ?', "%#{name}%")
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
  end

  # GET /customers/1/edit
  def edit; end

  # POST /customers or /customers.json
  def create
    @price = customer_params[:price].to_f
    @customer = Customer.new(customer_params.except(:price))
    respond_to do |format|
      if @price&.negative?
        flash.now[:error] = t('.negative')
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream
      elsif @customer.save
        Price.find(@customer.price.id).update!(quantity: @price)
        flash.now[:success] = t('.success')
        @customer.reload
        format.html { redirect_to customers_path }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    @price = customer_params[:price].to_f
    respond_to do |format|
      if @price&.negative?
        flash.now[:error] = t('.negative')
        format.html { render :edit, status: :unprocessable_entity }
      elsif @customer.update(customer_params.except(:price)) && @price
        Price.find(@customer.price.id)
             .update!(quantity: customer_params[:price])
        @customer.reload
        flash.now[:success] = t('.success')
        format.html { redirect_to customers_path }
      else
        flash.now[:error] = t('.error')
        format.html { render :edit, status: :unprocessable_entity }
      end
      format.turbo_stream
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
    params.require(:customer).permit(:name, :price)
  end
end
