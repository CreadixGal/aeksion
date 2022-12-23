file_name = 'pale.jpg'
file_path = Rails.root.join('spec', 'factories', 'images', file_name)
Faker::Config.locale = :es

User.create!(email: 'sadmin@test.com', password: 'test123', role: 'superadmin')

8.times do
  Customer.create!(name: Faker::Company.name)
end

4.times do |i|
  names = ['A coruña', 'Lugo', 'Ourense', 'Pontevedra']
  name = names.sample
  zone = Zone.new(name: name)
  names.delete(name)
  zone.name = name unless zone.save

  code = (i + 1).to_s.rjust(7, '0')
  product = Product.create!(
    code: "PR#{code}",
    price: rand(0.001..0.999),
    stock: rand(1350..9800),
    name: Faker::Commerce.product_name,
    kind: [2, 1].sample
  )

  product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
end

Customer.all.each do |customer|
  zone = Zone.all.sample
  Rate.create!(
    customer_id: customer.id,
    zone_id: zone.id,
    kind: 'delivery',
    price: rand(0.001..0.999)
  )
  Rate.create!(
    customer_id: customer.id,
    zone_id: zone.id,
    kind: 'pickup',
    price: rand(0.001..0.999)
  )
end

70.times do |i|
  3.times do
    rate = Rate.all.sample
    product = Product.all.sample
    random = rand(0..300)
    quantity = (product.stock - random).positive? ? random : 0
    next if quantity.zero?

    Movement.create!(
      rate_id: rate.id,
      date: (i + 2).days.ago,
      product_movements_attributes: [
        product_id: product.id,
        quantity:
      ]
    )
  end
end
