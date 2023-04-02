FactoryBot.define do
  factory :comment do
    user
    body { Faker::Lorem.paragraphs(number: 10) }
  end
end
