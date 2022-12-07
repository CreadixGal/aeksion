FactoryBot.define do
  factory :movement do
    association :rate, factory: :rate
    date { Time.zone.now }

    after(:create) do |movement|
      create(:product_movement, movement:)
    end
  end
end
