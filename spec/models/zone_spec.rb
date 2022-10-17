require 'rails_helper'

RSpec.describe Zone, type: :model do
  
  subject { Zone.new(name: Faker::Company.name) }

  it "is string" do
    expect(subject.name).to be_kind_of(String)
  end

  it "is Zone" do
    expect(subject).to be_kind_of(Zone)
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

  it "is a new zone and persisted" do
    expect(subject).to be_a_new(Zone)
  end

end
