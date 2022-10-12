require 'rails_helper'

RSpec.describe Customer, type: :model do
  before(:all) do
    @name = Faker::Company.name
    @customer = Customer.create(name: @name)
  end

  it "name is string" do
    expect(@customer.name).to be_kind_of(String)
  end

  it "this kind Customer" do
    expect(@customer).to be_kind_of(Customer)
  end

  it "value name" do
    expect(@customer.name).to eq(@name)
  end

  it "not null" do
    expect(@customer.name).to_not eq(nil)
  end

  it "persisted" do
    expect(@customer).to be_persisted
  end  
end
