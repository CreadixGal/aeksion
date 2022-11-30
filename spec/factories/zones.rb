FactoryBot.define do
  factory :zone do
    name { Zone::VALID_NAMES.sample }
  end
end
