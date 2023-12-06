class Price < ApplicationRecord
  belongs_to :priciable, polymorphic: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
