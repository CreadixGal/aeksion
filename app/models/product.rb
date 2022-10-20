class Product < ApplicationRecord
  validates :code, presence: true
end
