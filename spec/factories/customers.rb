FactoryBot.define do
  factory :customer do
    name { "test #{Faker::Company.name}" }
  end
end
