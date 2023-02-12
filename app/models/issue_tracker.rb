class IssueTracker < ApplicationRecord
  has_many_attached :images

  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, :description, presence: true
  validates :title,
            length: {
              minimum: 10,
              maximum: 100,
              message: 'must be between 10 and 100 characters'
            }
  enum status: {
    pending: 'pending',
    viewed: 'viewed',
    in_progress: 'in_progress',
    completed: 'completed'
  }, _default: 'pending'

  scope :ordered, -> { includes([images_attachments: [:blob]]).order(created_at: :desc) }
  scope :pending_count, -> { where(status: :pending).count }
end
