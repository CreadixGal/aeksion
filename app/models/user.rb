class User < ApplicationRecord
  has_many :issue_trackers
  has_many :comments, as: :commentable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: Devise.email_regexp }

  # validates :phone, format: { with: /\A[0-9]{9}\z/, message: 'only allows 9 digits' }

  enum role: {
    superadmin: 'superadmin',
    admin: 'admin',
    user: 'user'
  }, _default: 'user'
  validates :role, presence: true

  def add_phone_prefix!
    self.phone = "+34#{phone}" unless phone.start_with?('+34')
    save!
  end
end
