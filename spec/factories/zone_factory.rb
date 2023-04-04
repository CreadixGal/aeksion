FactoryBot.define do
  factory :zone do
    name { |n| "Zone-#{n}" }
    after(:create) do |zone|
      create(:price, priciable: zone)
    end
  end
end
