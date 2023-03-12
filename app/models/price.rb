class Price < ApplicationRecord
  belongs_to :priciable, polymorphic: true

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :product_id,
            uniqueness: {
              scope: :priciable_id, if: :zone?
            }
  # rubocop:enable Rails/UniqueValidationWithoutIndex

  private

  def zone?
    return true if priciable_type == 'Zone'

    false
  end
end
