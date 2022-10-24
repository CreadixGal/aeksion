require 'rails_helper'

RSpec.describe Rate, type: :model do
  subject do

    @customer = Customer.create(name: "Juan")
    @zone = Zone.create(name: "Galicia")

    described_class.new(
      customer_id: @customer,
      zone_id: @zone,
      kind: 1,
      price: 0.5
    )
  end

  #it 'belongs' do
  #  pending 'test incompleto'
  #  expect(subject.customer_id).to belongs_to(:customer)
  #end

  #describe 'asliudbasibds' do
  #it {should belong_to :customer}
  #end

  it { is_expected.to belong_to(:zone) }

  

  it 'kind is integer' do
    expect(subject.kind).to be_a(Integer)
  end

  it 'price is float' do
    expect(subject.price).to be_a(Float)
  end

  it 'is Rate' do
    expect(subject).to be_a(described_class)
  end

  it 'is not null' do
    expect(subject).not_to be_nil
  end

  #it 'is valid with valid attributes' do
  #  expect(subject).to be_valid
  #end

  it 'is a new rate and persisted' do
    expect(subject).to be_a_new(described_class)
  end
end
