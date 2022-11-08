class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  validates :phone, :email, presence: true, uniqueness: true
  validates_format_of :email, with: Devise.email_regexp
  # validates :phone, format: { with: /\A[0-9]{9}\z/, message: 'only allows 9 digits' }
  enum :role, { superadmin: 0, admin: 1, user: 2 }, field: { type: Integer, default: 2 }, map: :string, source: :role

  def add_phone_prefix!
    self.phone = "+34#{phone}" unless phone.start_with?('+34')
    save!
  end
end
