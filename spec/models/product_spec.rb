require 'rails_helper'

RSpec.describe Product, type: :model do
  subject do
    described_class.new(
      code: Faker::Company.name,
      kind: rand(1..2),
      name: Faker::Company.name,
      price: Faker::Commerce.price,
      stock: rand(1..100)
    )
  end

  it 'code is string' do
    expect(subject.code).to be_a(String)
  end

  it 'name is string' do
    expect(subject.name).to be_a(String)
  end

  it 'kind is integer' do
    expect(subject.kind).to be_a(Integer)
  end

  it 'stock is integer' do
    expect(subject.stock).to be_a(Integer)
  end

  it 'price is float' do
    expect(subject.price).to be_a(Float)
  end

  it 'is Product' do
    expect(subject).to be_a(described_class)
  end

  it 'is not null' do
    expect(subject).not_to be_nil
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without code' do
    subject.code = nil
    expect(subject).not_to be_valid
  end

  it 'code is not empty' do
    expect(subject.code).not_to be_empty
  end

  it 'is a new product and persisted' do
    expect(subject).to be_a_new(described_class)
  end
end
