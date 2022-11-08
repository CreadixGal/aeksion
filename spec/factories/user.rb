FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    surname { Faker::Name.last_name }
    phone { Faker::PhoneNumber.cell_phone }
    email { Faker::Internet.email }
    role  { 'user' }
  end
end
