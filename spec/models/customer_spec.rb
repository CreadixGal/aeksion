require 'rails_helper'

RSpec.describe Customer do
  subject { described_class.new(name: Faker::Company.name) }

  describe 'associations' do
    it { should have_many(:rates) }
    it { should have_many(:zones).through(:rates).dependent(:destroy) }
    it { should have_one(:price).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'callbacks' do
    it 'sets the product rate before creation' do
      pending 'TODO: Fix this test'
      product_zone = Zone.find_by(name: 'Product')
      expect(customer.rates.find_by(zone: product_zone, kind: 'pickup')).to be_present
    end

    it 'creates a default price after creation' do
      pending 'TODO: Fix this test'
      expect(customer.price).to be_present
      expect(customer.price_quantity).to eq(0)
    end
  end

  describe 'scopes' do
    # let!(:customer1) { create(:customer) }
    # let!(:customer2) { create(:customer) }

    context 'ordered' do
      it 'returns customers in descending order of update time' do
        pending 'TODO: Fix this test'
        expect(Customer.ordered).to eq([customer2, customer1])
      end
    end
  end

  it 'is string' do
    expect(subject.name).to be_a(String)
  end

  it 'is Customer' do
    expect(subject).to be_a(described_class)
  end

  it 'is not null' do
    expect(subject).not_to be_nil
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it 'name is not empty' do
    expect(subject.name).not_to be_empty
  end

  it 'is a new customer and persisted' do
    expect(subject).to be_a_new(described_class)
  end
end
