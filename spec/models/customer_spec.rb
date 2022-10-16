require 'rails_helper'

RSpec.describe Customer, type: :model do
  before(:all) do
    @name = Faker::Company.name
    @customer = described_class.create!(name: @name)
  end

  it 'name is string' do
    expect(@customer.name).to be_a(String)
  end

  it 'this kind Customer' do
    expect(@customer).to be_a(described_class)
  end

  it 'value name' do
    expect(@customer.name).to eq(@name)
  end

  it 'not null' do
    expect(@customer.name).not_to be_nil
  end

  it 'persisted' do
    expect(@customer).to be_persisted
  end
end
