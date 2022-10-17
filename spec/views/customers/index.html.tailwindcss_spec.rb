require 'rails_helper'

RSpec.describe 'customers/index', type: :view do
  before do
    assign(:customers, [
             Customer.create!({ name: Faker::Company.name }),
             Customer.create!({ name: Faker::Company.name })
           ])
  end

  it 'renders a list of customers' do
    render
  end
end
