FactoryBot.define do
  factory :movement do
    association :rate, Rate.last
    date { Time.zone.now }
  end
end
