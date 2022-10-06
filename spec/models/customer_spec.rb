require 'rails_helper'

RSpec.describe Customer, type: :model do

  subject { Customer.new(name: Faker::Company.name) }

  it "is string" do
    expect(subject.name).to be_kind_of(String)
  end

  it "is Customer" do
    expect(subject).to be_kind_of(Customer)
  end

  it "is not null" do
    expect(subject).to_not eq(nil)
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
  it "name is not empty" do
    expect(subject.name).to_not be_empty
  end

  it "is a new customer and persisted" do
    expect(subject).to be_a_new(Customer)
  end

end