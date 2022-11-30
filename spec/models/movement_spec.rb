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

    it 'is a new zone and persisted' do
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
      puts subject.date.class
      expect(subject.date).to be_a(ActiveSupport::TimeWithZone)
    end
  end
end
