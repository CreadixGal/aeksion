FactoryBot.define do

  factory :price do
    type { 1 }
    customer { nil }
    zone { nil }
    product { nil }
    cost { nil }
  end

end
