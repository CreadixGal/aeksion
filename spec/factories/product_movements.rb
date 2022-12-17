FactoryBot.define do
  factory :product_movement do
    association :movement, factory: :movement
    association :product, factory: :product
    quantity { rand(1..50) }
  end
end
