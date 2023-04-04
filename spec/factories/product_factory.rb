FactoryBot.define do
  factory :product do
    name { "PR#{rand(1..9999)}" }
    kind { 'pallet' }
    stock { 10 }

    # after(:build) do |product|
    #   product.image
    #          .attach(
    #            io: Rails.root.join(
    #              'spec/fixtures/files/pale.jpg'
    #            ).open, filename: 'pale.jpg', content_type: 'image/jpeg'
    #          )
    # end

    trait :with_variants do
      transient do
        variants_count { 2 }
      end

      after(:create) do |product, evaluator|
        create_list(:variant, evaluator.variants_count, product:, zone: Zone.first)
      end
    end

    trait :with_movements do
      transient do
        movements_count { 2 }
      end

      after(:create) do |product, evaluator|
        evaluator.movements_count.times do
          movement = create(:movement)
          create(:product_movement, product:, movement:)
        end
      end
    end
  end
end
