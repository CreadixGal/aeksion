class IssueTracker < ApplicationRecord
  has_many_attached :images

  validates :title, :description, presence: true
  validates :title,
            length: {
              minimum: 10,
              maximum: 100,
              message: 'must be between 10 and 100 characters'
            }
end
