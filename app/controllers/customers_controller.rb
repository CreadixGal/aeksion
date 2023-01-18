class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show edit update destroy]

  # GET /customers or /customers.json
  def index
    @customers = Customer.ordered
    @pagy, @customers = pagy(@customers)
  end

  def search
    @customers = Customer.all
    text_fragment = params[:name]
    @filtered_customers = @customers.select { |e| e.name.upcase.include?(text_fragment.upcase) }
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.update(
            'search_results',
            partial: 'customers/shared/search_results',
            locals: { customers: @filtered_customers }
          )
        ]
      end
    end
  end

  # GET /customers/1 or /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers or /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, success: 'Customer was successfully created.' }
        format.turbo_stream { flash.now[:success] = 'Customer was successfully created.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customers_path, success: 'Customer was successfully updated.' }
        format.turbo_stream { flash.now[:success] = 'Customer was successfully updated.' }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy!

    respond_to do |format|
      format.html { redirect_to customers_path, alert: 'Customer was successfully destroyed.' }
      format.turbo_stream { flash.now[:alert] = 'Customer was successfully destroyed.' }
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
    params.require(:customer).permit(:name)
  end
end
