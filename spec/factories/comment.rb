FactoryBot.define do
  factory :comment do
    body { Faker::Lorem.paragraph(sentence_count: 3) }
    user { create(:user) }
    association :commentable, factory: :issue_tracker
  end
end
