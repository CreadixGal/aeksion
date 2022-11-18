require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is a new user and persisted' do
      user = User.create! subject.attributes.merge!(password: Faker::Internet.password)
      expect(user).to be_persisted
    end
  end

  describe 'mandatory field' do
    context 'is valid with' do
      it 'email' do
        expect(subject).to be_valid
      end

      it 'password' do
        expect(subject).to be_valid
      end

      it 'role' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid without' do
      it 'email' do
        subject.email = nil
        expect(subject).not_to be_valid
      end
  
      it 'password' do
        subject.password = nil
        expect(subject).not_to be_valid
      end
  
      it 'role' do
        subject.role = nil
        expect(subject).not_to be_valid
      end
    end
  end


  context 'show error message' do
    it 'email can`t be blank' do
      subject.email = nil
      subject.save
      expect(subject.errors[:email]).to include("can't be blank")
    end

    it 'email doesn`t match format' do
      subject.email = 'email'
      subject.save
      expect(subject.errors[:email]).to include('is invalid')
    end

    it 'password can`t be blank' do
      subject.password = nil
      subject.save
      expect(subject.errors[:password]).to include("can't be blank")
    end
  end

  describe 'method' do
    context 'change role to' do
      it '#superadmin!' do
        subject.superadmin!
        expect(subject.role).to eq('superadmin')
      end
  
      it '#admin!' do
        subject.admin!
        expect(subject.role).to eq('admin')
      end
  
      it '#user!' do
        subject.user!
        expect(subject.role).to eq('user')
      end
    end
    
    context 'add phone prefix' do
      it '#add_phone_prefix!' do
        subject.phone = '123456789'
        subject.add_phone_prefix!
        expect(subject.phone).to eq('+34123456789')
      end
    end
  end
end
