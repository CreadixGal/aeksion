require 'rails_helper'

RSpec.describe 'customers/new', type: :view do
  before do
    assign(:customer, Customer.new({ name: Faker::Company.name }))
  end

  it 'renders new customer form' do
    render

    assert_select 'form[action=?][method=?]', customers_path, 'post' do
    end
  end
end
