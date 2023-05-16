require 'rails_helper'

RSpec.describe "delivery_riders/new", type: :view do
  before(:each) do
    assign(:delivery_rider, DeliveryRider.new(
      name: "MyString"
    ))
  end

  it "renders new delivery_rider form" do
    render

    assert_select "form[action=?][method=?]", delivery_riders_path, "post" do

      assert_select "input[name=?]", "delivery_rider[name]"
    end
  end
end
