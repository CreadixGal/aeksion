FactoryBot.define do
  factory :rate do
    customer { nil }
    zone { nil }
    kind { 1 }
    price { 1.5 }
  end
end
