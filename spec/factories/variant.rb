FactoryBot.define do
  zone = Zone.all.sample
  factory :variant do
    code { "#{product.name}-#{zone.name.downcase.tr('^a-z', '').slice(0, 2)}" }
    zone_id { SecureRandom.uuid }

    association :product

    price { Price.new(quantity: rand(0.001..0.999)) }
  end
end
