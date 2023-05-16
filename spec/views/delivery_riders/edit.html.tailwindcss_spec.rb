require 'rails_helper'

RSpec.describe "delivery_riders/edit", type: :view do
  before(:each) do
    @delivery_rider = assign(:delivery_rider, DeliveryRider.create!(
      name: "MyString"
    ))
  end

  it "renders the edit delivery_rider form" do
    render

    assert_select "form[action=?][method=?]", delivery_rider_path(@delivery_rider), "post" do

      assert_select "input[name=?]", "delivery_rider[name]"
    end
  end
end
