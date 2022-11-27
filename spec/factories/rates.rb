FactoryBot.define do
  factory :rate do
    association :customer, factory: :customer
    association :zone, factory: :zone
    kind { 1 }
    price { 0.09 }
  end
end
