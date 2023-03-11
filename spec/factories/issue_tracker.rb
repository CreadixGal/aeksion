FactoryBot.define do
  factory :issue_tracker do
    title { Faker::Lorem.sentence(word_count: 3) }
    comments_attributes { [attributes_for(:comment)] }
    after(:build) do |issue|
      file_name = 'issue.jpg'
      file_path = Rails.root.join('spec', 'factories', 'images', file_name)
      issue.images.attach(io: File.open(file_path),
                          filename: file_name, content_type: 'image/png')
    end
  end
end
