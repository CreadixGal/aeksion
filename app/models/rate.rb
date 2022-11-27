class Rate < ApplicationRecord
  belongs_to :customer
  belongs_to :zone

  validates :price, presence: true

  def self.includes_all
    includes([:customer, :zone]).all
  end
end
