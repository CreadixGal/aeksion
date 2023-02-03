class Price < ApplicationRecord
  belongs_to :priciable, polymorphic: true

  # when cost_type is Zone -> delivery
  # #when cost_type is Customer -> pickup
end
