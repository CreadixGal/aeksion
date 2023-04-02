FactoryBot.define do
  factory :rate do
    kind { nil }
    association :customer, factory: :customer
    association :zone, factory: :zone
    after(:create) do |rate|
      rate.create_price(quantity: 1)
    end
  end
end
