require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product, :with_image) }

  context 'with all properly attributes' do
    # rubocop:disable RSpec/PredicateMatcher
    it 'has a valid factory' do
      expect(subject.valid?).to be_truthy
    end

    it 'is not null' do
      expect(subject).not_to be_nil
    end
  end

  context 'kind of field' do
    it 'code is String' do
      expect(subject.code).to be_a(String)
    end

    it 'name is String' do
      expect(subject.name).to be_a(String)
    end

    it 'stock is Integer' do
      expect(subject.stock).to be_a(Integer)
    end

    it 'price is Decimal' do
      expect(subject.price).to be_a(BigDecimal)
    end

    it 'kind is Integer' do
      expect(subject.kind).to be_a(Integer)
    end

    it 'product is Product' do
      expect(subject).to be_a(described_class)
    end

    it 'image is an ActiveStorage::Attached::One' do
      expect(subject.image).to be_a(ActiveStorage::Attached::One)
    end
  end

  context 'required field' do
    it 'must contain code' do
      expect(subject.code).not_to be_empty
    end

    it 'must contain price' do
      expect(subject.price).not_to be_blank
    end

    it 'must contain stock' do
      expect(subject.stock).not_to be_blank
    end

    # rubocop:disable RSpec/FactoryBot/SyntaxMethods
    product_no_code  = FactoryBot.build(:product, code: nil)
    product_no_price = FactoryBot.build(:product, price: nil)
    product_no_stock = FactoryBot.build(:product, stock: nil)
    # rubocop:enable RSpec/FactoryBot/SyntaxMethods

    it 'code must not be empty' do
      expect(product_no_code.valid?).to be_falsey
    end
    # rubocop:enable RSpec/PredicateMatcher

    it 'price must not be empty' do
      expect(product_no_price.price).to be_falsey
    end

    it 'stock must not be empty' do
      expect(product_no_stock.stock).to be_falsey
    end
  end

  it 'is a new product and persisted' do
    expect(subject).to be_a_new(described_class)
  end
end
