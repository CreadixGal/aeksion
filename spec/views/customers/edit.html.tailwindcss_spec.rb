require 'rails_helper'

RSpec.describe 'customers/edit', type: :view do
  before do
    @customer = assign(:customer, Customer.create!({ name: Faker::Company.name }))
  end

  it 'renders the edit customer form' do
    render

    assert_select 'form[action=?][method=?]', customer_path(@customer), 'post' do
    end
  end
end
