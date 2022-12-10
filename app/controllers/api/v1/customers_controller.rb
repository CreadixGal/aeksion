# rubocop:disable Rails/SkipsModelValidations
class Api::V1::CustomersController < Api::V1::BaseController
  before_action :set_customer, only: %i[show update destroy]

  def index
    customers = Customer.all
    json_render(customers)
  end

  def show
    json_render(@customer)
  end

  def create
    customer = Customer.create!(customer_params)
    json_render(customer)
  end

  def create_bulk
    customers = params[:customers].map do |customer|
      {
        name: customer[:name]
      }
    end

    Customer.upsert_all(customers)

    json_render(customers)
  end

  def update
    @customer.update!(customer_params)
    json_render(@customer)
  end

  def update_bulk
    customers = params[:customers].map do |customer|
      {
        id: customer[:id],
        name: customer[:name]
      }
    end

    Customer.upsert_all(customers, unique_by: :id, update_only: [:name])

    json_render(customers)
  end

  def destroy
    #@customer.rates.destroy! if @customer.rates.present?
    #@customer.destroy!
    customer = Customer.find(params[:customers][0][:id])
    customer.rates.destroy! if customer.rates.present?
    customer.destroy!
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customers).permit(:name)
  end
end

# rubocop:enable Rails/SkipsModelValidations
