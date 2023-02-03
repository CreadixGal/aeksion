class Price < ApplicationRecord
  belongs_to :priciable, polymorphic: true

  # when priciable is Zone -> delivery
  # when priciable is Customer -> pickup
end
