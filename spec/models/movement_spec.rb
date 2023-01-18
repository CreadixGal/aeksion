require 'rails_helper'

RSpec.describe Movement do
  subject { create(:movement) }

  describe 'associations' do
    it 'belongs to rate' do
      expect(subject.rate).to be_a(Rate)
    end
  end

  context 'with valid attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is a new movement and persisted' do
      movement = create(:movement)
      expect(movement).to be_persisted
    end
  end

  describe 'mandatory field' do
    it 'rate_id is string' do
      expect(subject.rate_id).to be_a(String)
    end

    it 'rate_id is not empty' do
      expect(subject.rate_id).not_to be_empty
    end

    it 'has a valid date' do
      expect(subject.date).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'code is present' do
      expect(subject.code).to be_present
    end
  end

  describe 'callbacks' do
    context 'before create' do
      it 'sets code' do
        movement = create(:movement)
        expect(movement.code).not_to be_nil
      end
    end
  end

  describe 'scopes' do
    describe '.delivery' do
      it 'returns only movements with rate of kind delivery' do
        Rate.destroy_all
        delivery = create(:movement, rate: create(:rate, :delivery))
        expect(described_class.delivery).to eq([delivery])
      end
    end

    describe '.pickup' do
      it 'returns only movements with rate of kind pickup' do
        Rate.destroy_all
        pickup = create(:movement, rate: create(:rate, :pickup))
        expect(described_class.pickup).to eq([pickup])
      end
    end
  end
end
