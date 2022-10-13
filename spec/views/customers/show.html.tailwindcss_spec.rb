require 'rails_helper'

RSpec.describe 'customers/show', type: :view do
  before do
    @customer = assign(:customer, Customer.create!({ name: Faker::Company.name }))
  end

  it 'renders attributes in <p>' do
    render
  end
end
