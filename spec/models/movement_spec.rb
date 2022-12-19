require 'rails_helper'

RSpec.describe Movement, type: :model do
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
    context '.delivery' do
      it 'returns only movements with rate of kind delivery' do
        Rate.destroy_all
        delivery = create(:movement, rate: create(:rate, :delivery))
        pickup = create(:movement, rate: create(:rate, :pickup))
        expect(Movement.delivery).to eq([delivery])
      end
    end
  
    context '.pickup' do
      it 'returns only movements with rate of kind pickup' do
        Rate.destroy_all
        delivery = create(:movement, rate: create(:rate, :delivery))
        pickup = create(:movement, rate: create(:rate, :pickup))
        expect(Movement.pickup).to eq([pickup])
      end
    end
  end

  describe '#run_code' do
    context 'when rate is pickup' do
      it 'sets code based on the last pickup movement' do
        Rate.destroy_all
        rate = create(:rate, :pickup)
        last_pickup = create(:movement, rate: rate)
        movement = create(:movement, rate: rate)
        last_code = last_pickup.code.to_s.slice(5, 7).to_i
        expect(movement.code.slice(5,7).to_i).to eq(last_code + 1)
      end
    end

    context 'when rate is delivery' do
      it 'sets code based on the last delivery movement' do
        Rate.destroy_all
        rate = create(:rate, :delivery)
        last_delivery = create(:movement, rate: rate)
        movement = create(:movement, rate: rate)
        last_code = last_delivery.code.slice(5,7).to_i
        expect(movement.code.slice(5,7).to_i).to eq(last_code + 1)
      end
    end
  end
end
