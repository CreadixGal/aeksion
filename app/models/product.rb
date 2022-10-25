class Product < ApplicationRecord
  has_one_attached :image
  validates :code, presence: true
end
