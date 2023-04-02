FactoryBot.define do
  factory :rate do
    customer
    zone
    kind { 'delivery' }
    association :price, factory: :price, priciable: :rate
  end
end
