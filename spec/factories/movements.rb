FactoryBot.define do
  factory :movement do
    association :rate, factory: :rate
    date { Time.zone.now }
  end
end
