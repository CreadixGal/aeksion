file_name = 'pale.jpg'
file_path = Rails.root.join('spec', 'factories', 'images', file_name)

25.times do
  product = Product.create!(
    code: SecureRandom.hex(8).to_s,
    price: rand(0.001..0.999),
    stock: rand(1..800),
    name: Faker::Commerce.product_name,
    kind: [2, 1].sample
  )

  product.image.attach(io: File.open(file_path), filename: file_name, content_type: 'image/jpeg')
end

30.times do
  Customer.create!(name: Faker::Company.name)
end
