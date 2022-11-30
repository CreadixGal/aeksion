# rubocop:disable Rails/SkipsModelValidations
class Api::V1::CustomersController < Api::V1::BaseController
  def index
    customers = Customer.all
    json_render(customers)
  end

  def show
    customer = Customer.find(params[:id])
    json_render(customer)
  end

  def create
    customers = params[:customers].map do |customer|
      {
        name: customer[:name]
      }
    end

    Customer.upsert_all(customers)

    json_render(customers)
  end

  def bulk_update
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
    customer = Customer.find(params[:customers][0][:id])
    customer.rates.destroy! if customer.rates.present?
    customer.destroy!
  end
end

# rubocop:enable Rails/SkipsModelValidations
