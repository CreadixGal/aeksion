require 'rails_helper'

RSpec.describe Zone, type: :model do
  subject { described_class.new(name: Zone::VALID_NAMES.sample) }

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
      expect(subject).to be_a(Zone)
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
    it 'name can`t be blank' do
      pending 'not show error message ❌'
      subject.name = ''
      subject.save!
      expect(subject.errors[:name]).to include("can't be blank")
    end
  end
end
