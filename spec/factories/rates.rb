FactoryBot.define do
  factory :rate do
    association :customer, factory: :customer
    association :zone, factory: :zone
    kind { %w[delivery pickup].sample }
    price { 0.09 }
  end
end
