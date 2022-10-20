FactoryBot.define do
  factory :product do
    code { 'MyString' }
    kind { 1 }
    name { 'MyString' }
    price { 1.5 }
    stock { 1 }
  end
end
