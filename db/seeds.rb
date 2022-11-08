file_name = 'pale.jpg'
file_path = Rails.root.join('spec', 'factories', 'images', file_name)
Faker::Config.locale = :es

25.times do
end

4.times do
  Zone.create!(name: Faker::Address.community)
  Customer.create!(name: Faker::Company.name)
  Rate.create!(
    customer: Customer.all.sample.id,
    zone: Zone.all.sample.id,
    kind: 0,
    price: rand(0.001..0.999)
  )

  product = Product.create!(
    code: SecureRandom.hex(8).to_s,
    price: rand(0.001..0.999),
    stock: rand(1..800),
    name: Faker::Commerce.product_name,
    kind: [2, 1].sample
  )

  product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
  user = User.create!(
    name: Faker::Name.name,
    surname: Faker::Name.last_name,
    phone: Faker::PhoneNumber.phone_number,
    email: Faker::Internet.email,
    password: SecureRandom.hex(8),
    role: %w[admin user].sample
  )
  user.add_phone_prefix!
end

300.times do
  Movement.create!(
    customer_id: Customer.all.sample.id,
    user_id: User.all.sample.id,
    date: Faker::Date.between(from: '2020-01-01', to: '2022-11-01'),
    price: rand(0.001..0.999),
    kind: [1, 2].sample
  )

  ProductMovement.create!(
    product_id: Product.all.sample.id,
    movement_id: Movement.all.sample.id,
    quantity: rand(1..800)
  )
end
