require 'rails_helper'

RSpec.describe 'customers/show' do
  before do
    @customer = assign(:customer, Customer.create!({ name: Faker::Company.name }))
  end

  it 'renders attributes in <p>' do
    skip 'not implemented yet'
    render
  end
end
