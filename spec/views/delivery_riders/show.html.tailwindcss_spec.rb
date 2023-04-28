require 'rails_helper'

RSpec.describe "delivery_riders/show", type: :view do
  before(:each) do
    @delivery_rider = assign(:delivery_rider, DeliveryRider.create!(
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
