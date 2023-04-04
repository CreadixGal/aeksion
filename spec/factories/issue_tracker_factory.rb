FactoryBot.define do
  factory :issue_tracker do
    title { Faker::Lorem.sentence(word_count: 3) }
    user
    status { 'pending' }
    after(:build) do |issue|
      file_name = 'issue.jpg'
      file_path = Rails.root.join('spec', 'fixtures', 'files', file_name)
      issue.images.attach(io: File.open(file_path),
                          filename: file_name, content_type: 'image/png')
    end

    after(:build) do |issue|
      issue.comments << build(:comment)
    end
  end
end
