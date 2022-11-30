require 'rails_helper'

RSpec.describe Rate, type: :model do
  subject { create(:rate) }

  context 'with valid attributes' do
    it 'is a new rate' do
      expect(build(:rate)).to be_a_new(described_class)
    end

    it 'is valid' do
      puts subject.inspect
      expect(subject).to be_valid
    end

    it 'is a new rate and persisted' do
      expect(subject).to be_persisted
    end
  end

  describe 'mandatory field' do
    it 'customer_id is string' do
      expect(subject.customer_id).to be_a(String)
    end

    it 'customer_id is not empty' do
      expect(subject.customer_id).not_to be_empty
    end

    it 'zone_id is string' do
      expect(subject.zone_id).to be_a(String)
    end

    it 'zone_id is not empty' do
      expect(subject.zone_id).not_to be_empty
    end

    it 'price is BigDecimal' do
      expect(subject.price).to be_a(BigDecimal)
    end

    it 'price is not empty' do
      expect(subject.price).not_to be_blank
    end

    it 'kind is string' do
      expect(subject.kind).to be_a(String)
    end

    it 'kind is in enum' do
      expect(subject.kind).to be_in(described_class.kinds.keys)
    end
  end

  context 'associations' do
    it 'belongs_to customer' do
      expect(subject.customer).to be_a(Customer)
    end

    it 'belongs_to zone' do
      expect(subject.zone).to be_a(Zone)
    end
  end
end
