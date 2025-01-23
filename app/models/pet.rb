class Pet < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_breed_and_size_and_description_and_pet_name_and_available,
    against: [ :breed, :size, :description, :pet_name, :available],
    using: {
      tsearch: { prefix: true } # <-- now `superman batm` will return something!
    }

  belongs_to :user
  has_many :bookings, dependent: :destroy

  validates :pet_name, presence: true
  validates :breed, presence: true
  validates :age, presence: true
  validates :size, presence: true
  validates :description, presence: true
end
