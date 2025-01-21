class Pet < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy

  validates :pet_name, presence: true
  validates :breed, presence: true
  validates :age, presence: true
  validates :size, presence: true
  validates :description, presence: true
end
