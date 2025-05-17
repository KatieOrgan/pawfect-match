class Pet < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_breed_and_size_and_description_and_pet_name_and_available,
    against: [:breed, :size, :description, :pet_name],
    using: { tsearch: { prefix: true } }

  belongs_to :user
  has_one_attached :pet_photo
  has_many_attached :pet_photos
  has_many :bookings, dependent: :destroy

  validates :pet_name, :breed, :age, :size, :description, presence: true

  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  def available_now?
    return false unless available_from
    return Date.today >= available_from && (available_until.nil? || Date.today <= available_until)
  end
  
  VALID_SIZES = ["Small", "Medium", "Large"]
  VALID_ANIMALS = ["Dog", "Cat", "Rabbit", "Hamster", "Bird", "Reptile"]

  validates :size, inclusion: { in: VALID_SIZES }
  validates :breed, inclusion: { in: VALID_ANIMALS } 
end
