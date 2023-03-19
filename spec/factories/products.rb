FactoryBot.define do
  factory :product do
    name { "PR#{rand(0..999)}" }
    kind { 1 }
    stock { rand(190..800) }

    after(:create) do |product|
      create(:variant, product:)
    end

    trait :with_image do
      after :build do |product|
        file_name = 'pale.jpg'
        file_path = Rails.root.join('spec', 'factories', 'images', file_name)
        product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
      end
    end
  end
end
