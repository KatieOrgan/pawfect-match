class Pet < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_breed_and_size_and_description_and_pet_name_and_available,
    against: [:breed, :size, :description, :pet_name, :available],
    using: { tsearch: { prefix: true } }

  belongs_to :user
  has_one_attached :pet_photo
  has_many_attached :pet_photos
  has_many :bookings, dependent: :destroy

  validates :pet_name, :breed, :age, :size, :description, presence: true

  geocoded_by :location
  after_validation :geocode, if: :location_changed?
end
