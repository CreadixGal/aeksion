require 'faker'

file_name = 'pale.jpg'
file_path = Rails.root.join('spec', 'factories', 'images', file_name)
Faker::Config.locale = :es

# create users (superadmin and admin)
User.create!(email: 'sadmin@test.com', password: 'test123', role: 'superadmin')
User.create!(email: 'admin@test.com', password: 'test123', role: 'admin')

# create 8 customers
8.times do
  Customer.create!(name: Faker::Company.name)
end

# crete 4 zones
co = Zone.create!(name: 'A Coruña')
lu = Zone.create!(name: 'Lugo')
ou = Zone.create!(name: 'Ourense')
po = Zone.create!(name: 'Pontevedra')

[co, lu, ou, po].each do |zone|
  zone.price = Price.new(quantity: rand(0.001..0.999))
  zone.save!
end

# create rates
Customer.all.each do |customer|
  zone = Zone.all.sample
  del = zone.rates.build(
    customer_id: customer.id,
    kind: 'delivery'
  )
  del.prices.build(quantity: rand(0.001..0.999))
  del.save!
  puts "\n📦 Delivery rate created    #{del} 📦\n"

  pic = zone.rates.build(
    customer_id: customer.id,
    kind: 'pickup'
  )
  pic.prices.build(quantity: rand(0.001..0.999))
  pic.save!
  puts "\n📦 Pickup rate created      #{pic} 📦\n"
end

# create isolate single products
5.times do
  code = rand(1000..9999)
  product = Product.new(
    name: "PR#{code}",
    stock: rand(1350..9800),
    kind: [2, 1].sample
  )
  product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
  product.save!
  puts "\n📦 Product #{product.name} created     📦\n"
  Zone.all.each do |zone|
    variant = product.variants.build(code: "PR#{code}-#{zone.name.downcase.tr('^a-z', '').slice(0,2)}", zone_id: zone.id)
    variant.price = Price.new(quantity: rand(0.0001..0.9999))
    variant.save!
    puts "📦 Variant: #{variant.code} with price #{variant.quantity} created     📦\n"
  end
end

two_years_ago = 1.year.ago
idx = 0
while two_years_ago <= Time.zone.now
  two_years_ago += 1.day
  next if two_years_ago.saturday? || two_years_ago.sunday?

  puts amount = rand(6..22)

  amount.times do
    idx += 1
    rate = Rate.all.sample
    product = Product.all.sample
    random = rand(1..300)
    quantity = (product.stock - random).positive? ? random : 0
    next if quantity.zero?

    mov = Movement.create!(
      code: "ALB-#{Faker::Code.ean}",
      rate_id: rate.id,
      date: two_years_ago,
      product_movements_attributes: [
        product_id: product.id,
        quantity:
      ]
    )
    puts "📆 #{idx}: #{two_years_ago}: #{mov.persisted?}\n"
  end
end
