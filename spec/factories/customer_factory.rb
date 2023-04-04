FactoryBot.define do
  factory :customer do
    name { Faker::Name.name }
    association :price, factory: :price, strategy: :build
  end
end
