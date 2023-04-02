FactoryBot.define do
  factory :movement do
    association :rate, factory: :rate
    code { "ALB-#{Faker::Lorem.characters(number: 7)}" }
    date { Time.zone.now }

    after(:create) do |movement|
      create(:product_movement, movement:)
    end
  end
end
