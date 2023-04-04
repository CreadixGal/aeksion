require 'rails_helper'

RSpec.describe Rate, type: :model do
  let(:customer) { create(:customer) }
  let(:zone) { create(:zone) }
  let(:rate) { create(:rate, customer: customer, zone: zone) }

  describe 'associations' do
    it { is_expected.to belong_to(:customer).inverse_of(:rates) }
    it { is_expected.to belong_to(:zone).inverse_of(:rates) }
    it { is_expected.to have_many(:movements).dependent(:destroy) }
    it { is_expected.to have_one(:price).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:kind) }
  end

  describe 'enums' do
    it 'defines the enum for kind' do
      should define_enum_for(:kind).with_values(delivery: 'delivery', pickup: 'pickup', return: 'return').backed_by_column_of_type(:string) 
    end
  end

  describe 'scopes' do
    # let!(:delivery_rate) { create(:rate, kind: 'delivery') }
    # let!(:pickup_rate) { create(:rate, kind: 'pickup') }
    # let!(:return_rate) { create(:rate, kind: 'return') }

    context 'delivery' do
      it 'returns delivery rates' do
        pending 'TODO: Fix this test'
        expect(described_class.delivery).to include(delivery_rate)
      end
    end

    context 'pickup' do
      it 'returns pickup rates' do
        pending 'TODO: Fix this test'
        expect(described_class.pickup).to include(pickup_rate)
      end
    end

    context 'return' do
      it 'returns return rates' do
        pending 'TODO: Fix this test'
        expect(described_class.return).to include(return_rate)
      end
    end
  end

  describe 'callbacks' do
    it 'updates the name after saving' do
      pending 'TODO: Fix this test'
      expect(rate.name).to eq("#{customer.name}-#{zone.name.downcase.tr('^a-z', '').slice(0, 2)}")
    end
  end
end
