FactoryBot.define do
  factory :product do
    code { SecureRandom.hex(8).to_s }
    kind { [1, 2].sample }
    name { Faker::Commerce.product_name }
    price { rand(0.001..0.999) }
    stock { rand(1..800) }

    trait :with_image do
      after :build do |product|
        file_name = 'pale.jpg'
        file_path = Rails.root.join('spec', 'factories', 'images', file_name)
        product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
      end
    end
  end
end
