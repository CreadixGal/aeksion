class Api::V1::CustomersController < Api::V1::BaseController
  def index
    @customers = Customer.all
    json_render(@customers)
  end
end
