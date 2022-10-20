class Rate < ApplicationRecord
  belongs_to :customer
  belongs_to :zone
end
