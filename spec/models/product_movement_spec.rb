require 'rails_helper'

RSpec.describe ProductMovement do
  subject { create(:movement) }

  let(:delivery_valid_product_movement) do
    {
      rate_id: create(:rate, kind: 'delivery').id,
      date: Time.zone.now,
      code: 'ALB-1234567',
      product_movements_attributes: [
        product_id: create(:product, stock: 10).id,
        quantity: 9
      ]
    }
  end

  let(:delivery_invalid_product_movement) do
    {
      rate_id: create(:rate, kind: 'delivery').id,
      date: Time.zone.now,
      code: 'ALB-1234568',
      product_movements_attributes: [
        product_id: create(:product, stock: 10).id,
        quantity: 11
      ]
    }
  end

  let(:pickup_product_movement) do
    {
      rate_id: create(:rate, kind: 'pickup').id,
      date: Time.zone.now,
      code: 'ALB-1234569',
      product_movements_attributes: [
        product_id: create(:product, stock: 10).id,
        quantity: 90
      ]
    }
  end

  describe 'associations' do
    it 'belongs to Prouduct throug movements' do
      expect(subject.product_movements.first.product).to be_a(Product)
    end

    it 'belongs to Movement' do
      expect(subject.product_movements.first.movement).to be_a(Movement)
    end
  end

  describe '#enough_stock' do
    it 'delivery is valid' do
      movement = Movement.create!(delivery_valid_product_movement)
      expect(movement).to be_valid
    end

    it 'delivery is invalid' do
      movement = Movement.new(delivery_invalid_product_movement)
      expect { movement.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#recalculate_stock' do
    it '#add_stock_to_product' do
      movement = Movement.create!(pickup_product_movement)
      expect(movement.products.first.stock).to eq(100)
    end

    it '#substract_stock_to_product' do
      movement = Movement.create!(delivery_valid_product_movement)
      expect(movement.products.first.stock).to eq(1)
    end
  end
end
