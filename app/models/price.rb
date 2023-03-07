class Price < ApplicationRecord
  belongs_to :priciable, polymorphic: true

  validates_uniqueness_of :product_id, scope: :priciable_id, if: :zone?

  private

  def zone?
    return true if priciable_type == "Zone"
    false
  end

end
