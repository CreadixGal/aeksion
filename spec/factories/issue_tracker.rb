FactoryBot.define do
  factory :issue_tracker do
    title { "test #{Faker::Lorem.sentence}" }
    description { "test #{Faker::Lorem.paragraphs.split(',').join(',')}" }

    trait :with_image do
      after :build do |issue|
        file_name = 'issue.jpg'
        file_path = Rails.root.join('spec', 'factories', 'images', file_name)
        issue.images.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
      end
    end
  end
end
