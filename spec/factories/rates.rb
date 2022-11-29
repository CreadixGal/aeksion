FactoryBot.define do
  factory :rate do
    association :customer, factory: :customer
    association :zone, Zone.first
    kind { ['delivery', 'pickup'].sample }
    price { 0.09 }
  end
end
