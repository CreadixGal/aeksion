class Price < ApplicationRecord
  belongs_to :priciable, polymorphic: true
end
