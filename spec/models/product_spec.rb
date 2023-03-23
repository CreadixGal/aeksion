require 'rails_helper'

RSpec.describe Product do
  before do
    create(:zone)
  end

  describe 'validations' do
    let(:product) { create(:product) }

    it 'is valid with valid attributes' do
      expect(product).to be_valid
    end

    it 'is not valid without stock' do
      product.stock = nil
      expect(product).not_to be_valid
    end

    it 'is not valid with negative stock' do
      product.stock = -1
      expect(product).not_to be_valid
    end

    it 'is valid with zero stock' do
      product.stock = 0
      expect(product).to be_valid
    end

    it 'is not valid without kind' do
      product.kind = nil
      expect(product).not_to be_valid
    end
  end

  describe 'associations' do
    let(:product) { create(:product, :with_variants) }

    it 'has many variants' do
      variant1 = product.variants.first
      variant2 = product.variants.last
      expect(product.variants).to include(variant1, variant2)
    end

    it 'destroys variants when destroyed' do
      variant = product.variants.first
      product.destroy!
      expect(Variant.all).not_to include(variant)
      expect { variant.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'has one attached image' do
      expect(product.image).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  describe 'nested attributes' do
    it 'accepts nested attributes for variants' do
      expect(described_class.new.variants_attributes = ([{}])).to be_truthy
    end
  end

  describe 'enums' do
    let(:product) { create(:product) }

    it 'has an enum for kind' do
      expect(product).to respond_to(:pallet?)
      expect(product).to respond_to(:box?)
    end
  end
end
