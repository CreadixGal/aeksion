class Rate < ApplicationRecord
  belongs_to :customer
  belongs_to :zone
  has_many :movements, dependent: :destroy
end
