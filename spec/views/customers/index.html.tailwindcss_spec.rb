require 'rails_helper'

RSpec.describe 'customers/index' do
  before do
    assign(:customers, [
             Customer.create!({ name: Faker::Company.name }),
             Customer.create!({ name: Faker::Company.name })
           ])
  end

  it 'renders a list of customers' do
    pending 'pagy.prev and pagy.next are not working'
    render
  end
end
