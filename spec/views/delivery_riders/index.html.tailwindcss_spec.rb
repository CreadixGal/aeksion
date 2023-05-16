require 'rails_helper'

RSpec.describe "delivery_riders/index", type: :view do
  before(:each) do
    assign(:delivery_riders, [
      DeliveryRider.create!(
        name: "Name"
      ),
      DeliveryRider.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of delivery_riders" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
