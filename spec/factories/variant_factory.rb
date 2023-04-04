FactoryBot.define do
  factory :variant do
    product
    zone { Zone.first }
    code { "#{product.name}-#{zone.name.downcase.tr('^a-z', '').slice(0, 2)}" }
  end
end
