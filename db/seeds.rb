require 'faker'

file_name = 'pale.jpg'
file_path = Rails.root.join("spec/fixtures/files/#{file_name}")

Faker::Config.locale = :en

# create users (superadmin and admin)
User.create!(email: 'sadmin@test.com', password: 'test123', role: 'superadmin')
User.create!(email: 'admin@test.com', password: 'test123', role: 'admin')
User.create!(email: 'creadix@creadix.es', password: 'test123', role: 'superadmin')
User.create!(email: 'admin@orpal.es', password: 'orpal123', role: 'admin')

# create 4 zones
co = Zone.create!(name: 'A Coruña')
lu = Zone.create!(name: 'Lugo')
ou = Zone.create!(name: 'Ourense')
po = Zone.create!(name: 'Pontevedra')
# create product zone
pr = Zone.create!(name: 'DEFAULT')
pr.price = Price.new(quantity: 0)
pr.save!

# add price to zones
[co, lu, ou, po].each do |zone|
  zone.price = Price.new(quantity: rand(0.001..0.999))
  zone.save!
end

# create 8 customers
8.times do
  Customer.create!(name: Faker::Company.name)
end

# create rates
Customer.all.each do |customer|
  [co, lu, ou, po].each do |zone|
    del = zone.rates.build(
      customer_id: customer.id,
      kind: 'delivery'
    )

    del.price = Price.new(quantity: rand(0.001..0.999))
    del.save!
    puts "\n📦 Delivery rate created    #{del} -> #{del.quantity}📦\n"
  end
end

# create isolate single products
5.times do
  code = rand(1000..9999)
  product = Product.new(
    name: "PR#{code}",
    stock: rand(55350..99800),
    kind: [2, 1].sample
  )
  product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
  product.save!
  puts "\n📦 Product #{product.name} created     📦\n"
  Zone.where.not(name: 'DEFAULT').each do |zone|
    variant = product.variants.build(
      code: "PR#{code}-#{zone.name.downcase.tr('^a-z', '').slice(0, 2)}",
      zone_id: zone.id
    )

    variant.price = Price.new(quantity: rand(0.0001..0.9999))
    variant.save!
    puts "📦 Variant: #{variant.code} with price #{variant.quantity} created     📦\n"
  end
end

def create_delivery_product_movement(rate)
  variant  = Variant.where(zone_id: rate.zone_id).sample
  product  = variant.product
  quantity = rand(1..100)

  { product_id: product.id, quantity: }
end

# two_years_ago = 1.year.ago
# idx = 0
# while two_years_ago <= Time.zone.now
#   two_years_ago += 1.day
#   next if two_years_ago.saturday? || two_years_ago.sunday?

#   rand(3..9).times do
#     idx += 1
#     customer = Customer.all.sample
#     rate = customer.rates.where(kind: 'delivery').sample
#     puts kind = %w[delivery pickup].freeze.sample

#     product_movements = []
#     3.times do
#       if kind == 'delivery'
#         product_movement = create_delivery_product_movement(rate)
#         puts "🐛 #{product_movement} 🐛\n"
#         if (Product.find(product_movement[:product_id]).stock - product_movement[:quantity]).positive?
#           product_movements << product_movement
#         end
#       else
#         product_movements << { product_id: Product.all.sample.id, quantity: rand(100..700) }
#       end
#     end
#     puts "🐛 #{product_movements} 🐛\n"

#     mov = Movement.new(
#       code: "ALB-#{idx.to_s.rjust(4, '0')}",
#       rate_id: rate.id,
#       date: two_years_ago,
#       product_movements_attributes: product_movements
#     )

#     if mov.save
#       puts "📆 #{idx} #{mov.rate_kind}: #{two_years_ago}: #{mov.persisted?}\n"
#     else
#       puts "⚠️⚠️⚠️\n\nErrors #{mov.rate_kind}: #{mov.errors.inspect}\n\n⚠️⚠️⚠️"
#     end
#   end
# end
