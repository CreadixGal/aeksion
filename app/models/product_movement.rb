class ProductMovement < ApplicationRecord
  belongs_to :movement
  belongs_to :product
end
