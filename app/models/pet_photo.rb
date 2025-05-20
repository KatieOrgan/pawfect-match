class PetPhoto < ApplicationRecord
  belongs_to :pet
  has_one_attached :image

  validates :image, presence: true
end
