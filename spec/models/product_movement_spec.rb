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
end
