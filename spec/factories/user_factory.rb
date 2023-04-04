FactoryBot.define do
  factory :user do
    name      { Faker::Name.name }
    surname   { Faker::Name.last_name }
    phone     { Faker::PhoneNumber.cell_phone }
    email     { "test_#{Faker::Internet.email}" }
    password  { Faker::Internet.password }
    role      { 'superadmin' }
  end
end
