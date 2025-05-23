class User < ApplicationRecord
  has_many :pets, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_one_attached :profile_picture

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :bio, presence: false
  validates :is_owner, inclusion: { in: [true, false], message: "must be true or false" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, if: :password_required?

  before_validation :set_defaults

  private

  def set_defaults
    self.is_owner = false if is_owner.nil?
  end

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

end
