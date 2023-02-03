class Price < ApplicationRecord
  belongs_to :cost, polymorphic: true

  # when cost_type is Zone -> delivery
  # #when cost_type is Customer -> pickup

end
