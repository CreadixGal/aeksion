require 'rails_helper'

RSpec.describe User do
  subject { build(:user) }

  after(:all) { described_class.all.each { |user| user.delete! if user.email.include?('test_') } }

  context 'with valid attributes' do
    it 'is valid' do
      expect(subject).to be_valid
    end

    it 'is a new user and persisted' do
      user = described_class.create! subject.attributes.merge!(password: Faker::Internet.password)
      expect(user).to be_persisted
    end
  end

  # rubocop:disable RSpec/RepeatedExample
  describe 'mandatory field' do
    context 'is valid' do
      it 'with email' do
        expect(subject).to be_valid
      end

      it 'with password' do
        expect(subject).to be_valid
      end

      it 'with role' do
        expect(subject).to be_valid
      end
    end

    context 'is not valid' do
      it 'without email' do
        subject.email = nil
        expect(subject).not_to be_valid
      end

      it 'without password' do
        subject.password = nil
        expect(subject).not_to be_valid
      end

      it 'without role' do
        subject.role = nil
        expect(subject).not_to be_valid
      end
    end
  end
  # rubocop:enable RSpec/RepeatedExample

  # rubocop:disable Rails/SaveBang
  context 'show error message' do
    it 'email can`t be blank' do
      subject.email = nil
      subject.save
      expect(subject.errors[:email].first).to include('Email no puede estar en blanco')
    end

    it 'email doesn`t match format' do
      subject.email = 'email'
      subject.save
      expect(subject.errors[:email].first).to include('Email no es válido')
    end

    it 'password can`t be blank' do
      subject.password = nil
      subject.save
      expect(subject.errors[:password]).to include('Password no puede estar en blanco')
    end
  end
  # rubocop:enable Rails/SaveBang

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
