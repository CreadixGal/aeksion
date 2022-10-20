require 'rails_helper'

RSpec.describe Rate, type: :model do
  subject { described_class.new(customer_id: 1, zone_id: 1, kind: 1, price: 0.5) }

  it 'belongs' do
    pending 'test incompleto'
    expect(subject.customer_id).to belong_to(:customer)
  end

  it 'kind is integer' do
    expect(subject.kind).to be_a(Integer)
  end

  it 'price is float' do
    expect(subject.price).to be_a(Float)
  end
end
