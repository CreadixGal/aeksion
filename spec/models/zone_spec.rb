require 'rails_helper'

RSpec.describe Zone do
  subject { described_class.new(name: described_class::VALID_NAMES.sample) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is a new zone and persisted' do
      zone = described_class.create! name: 'random'
      expect(zone).to be_persisted
    end
  end

  describe 'mandatory field' do
    it 'name is string' do
      expect(subject.name).to be_a(String)
    end

    it 'class is Zone' do
      expect(subject).to be_a(described_class)
    end

    it 'class is not null' do
      expect(subject).not_to be_nil
    end

    it 'is not valid without name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'name is not empty' do
      expect(subject.name).not_to be_empty
    end
  end

  describe 'show error message' do
    it 'raise an ActiveRecord::RecordInvalid error' do
      subject.name = ''
      expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
