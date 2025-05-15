require 'faker'
require 'open-uri'

puts "Cleaning up old records..."
Booking.destroy_all
Pet.destroy_all
User.destroy_all

puts "Creating a user..."
user = User.create!(
  username: "test",
  email: "test@example.com",
  password: "123456",
  first_name: "Joshua",
  last_name: "Thomas",
  bio: Faker::Lorem.sentence,
  is_owner: true
)

puts "Attaching a profile picture to the user..."
# Example remote image URL (you can use any valid image link here)
profile_picture_file = File.open(Rails.root.join("db/seed_images/profile_placeholder.png"))

user.profile_picture.attach(
  io: profile_picture_file,
  filename: "profile_placeholder.png",
  content_type: "image/png"
)

puts "User created with an attached profile picture!"

# -------------------------------
# Now let's seed some pets
# -------------------------------

puts "Creating some pets..."

def create_pet(attributes)
  pet = Pet.new(attributes.except(:photo_url))
  pet.geocode
  pet.save!

  if attributes[:photo_url]
    photo_file = URI.open(attributes[:photo_url])
    pet.pet_photo.attach(
      io: photo_file,
      filename: "#{pet.pet_name.downcase}.jpg",
      content_type: "image/jpg"
    )
  end

  puts "Pet '#{pet.pet_name}' created with photo and geocoded!"
end

create_pet(
  pet_name: 'Ziggy',
  breed: 'Springer Spaniel',
  age: rand(1..15),
  size: 'Medium',
  description: "Ziggy has a wagging tail that never stops. His favorite thing in the world is going on long walks!",
  available_from: Date.today + rand(1..10),
  available_until: Date.today + rand(20..40),
  highlights: "Great with kids · Loves long walks · Very cuddly",
  booked: false,
  location: "Leeds",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1723580729235-bc20921020e0?q=80&w=1374&auto=format&fit=crop'
)

puts "Pet 'Ziggy' created and photo attached!"

create_pet(
  pet_name: 'Whiskers',
  breed: 'Dwarf Hamster',
  age: rand(1..5),
  size: 'Small',
  description: "Meet Whiskers, a hyperactive hamster who treats his wheel like a racetrack!",
  available_from: Date.parse('2025-05-16'),
  available_until: Date.parse('2025-06-07'),
  highlights: "Low maintenance · House-trained · Great with kids",
  booked: false,
  location: "York",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1622946377594-f0c462f11b20?q=80&w=1335&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Slytherin',
  breed: 'Corn Snake',
  age: rand(1..20),
  size: 'Medium',
  description: "Slither is a mellow ball python who loves curling up in his favorite hide and lazily watching the world go by.",
  available_from: Date.parse('2025-05-19'),
  available_until: Date.parse('2025-06-13'),
  highlights: "Great with kids · Fully vaccinated · Calm and gentle",
  booked: false,
  location: "Bristol",
  user: user,
  photo_url: 'https://ugc.naturalatlas.com/photos/0/151/979/151979/tnT3a55o/1200.jpg?1627026957'
)

create_pet(
  pet_name: 'Dinky',
  breed: 'Tabby Cat',
  age: rand(1..5),
  size: 'Medium',
  description: "Luna is a fiercely independent tabby who spends her days lounging in sunbeams and silently judging your life choices.",
  available_from: Date.parse('2025-05-18'),
  available_until: Date.parse('2025-06-11'),
  highlights: "Low maintenance · Great with kids · Fully vaccinated",
  booked: false,
  location: "Leeds",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1613467402748-2fe094a5cde0?q=80&w=1374&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Noodle',
  breed: 'Sausage Dog',
  age: rand(1..8),
  size: 'Small',
  description: "Noodle is an energetic dachshund with a knack for sneaking treats when no one’s looking.",
  available_from: Date.parse('2025-05-18'),
  available_until: Date.parse('2025-06-03'),
  highlights: "Playful · Fully vaccinated · Calm and gentle",
  booked: false,
  location: "Manchester",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1621757298894-7174d1b1bc40?q=80&w=1374&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Floppy',
  breed: 'Rex Rabbit',
  age: rand(1..10),
  size: 'Small',
  description: "Floppy is a curious little bunny with a soft, twitchy nose and a love for munching on fresh greens.",
  available_from: Date.parse('2025-05-14'),
  available_until: Date.parse('2025-06-06'),
  highlights: "Calm and gentle · Fully vaccinated · House-trained",
  booked: false,
  location: "Cambridge",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1535241749838-299277b6305f?q=80&w=1346&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Sid & Ralph',
  breed: 'Abyssinian Guinea Pigs',
  age: rand(1..8),
  size: 'Small',
  description: "Meet the dynamic duo, Sid and Ralph, two brother guinea pigs with hearts as big as their appetites!",
  available_from: Date.parse('2025-05-17'),
  available_until: Date.parse('2025-06-01'),
  highlights: "Low maintenance · Great with kids · Energetic",
  booked: false,
  location: "Sheffield",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1548767797-d8c844163c4c?q=80&w=1171&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Paws',
  breed: 'Persian Cat',
  age: rand(1..8),
  size: 'Small',
  description: "Meet Paws, a fluffy ball of charm with a purr that can melt anyone’s heart.",
  available_from: Date.parse('2025-05-21'),
  available_until: Date.parse('2025-06-06'),
  highlights: "Calm and gentle · Fully vaccinated · Playful",
  booked: false,
  location: "Newcastle",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1548366086-7f1b76106622?q=80&w=1352&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Carly',
  breed: 'Cockatiel',
  age: rand(1..10),
  size: 'Small',
  description: "Meet Carly, the sweetest little cockatiel with a heart full of song and feathers full of personality!",
  available_from: Date.parse('2025-05-17'),
  available_until: Date.parse('2025-06-09'),
  highlights: "Loves cuddles · Great with kids · Energetic",
  booked: false,
  location: "Birmingham",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1458410489211-ba19aa2f2902?w=500&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Caramel',
  breed: 'American Fuzzy Lop Rabbit',
  age: rand(1..5),
  size: 'Small',
  description: "Meet Caramel, the fluffiest bundle of joy you’ll ever meet!",
  available_from: Date.parse('2025-05-14'),
  available_until: Date.parse('2025-06-03'),
  highlights: "Playful · House-trained · Great with kids",
  booked: false,
  location: "Cardiff",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1452857297128-d9c29adba80b?q=80&w=1374&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Pepe',
  breed: 'Shihtzu Dog',
  age: rand(1..12),
  size: 'Small',
  description: "This sweet Shih Tzu may be small, but he’s got a personality that fills the room.",
  available_from: Date.parse('2025-05-14'),
  available_until: Date.parse('2025-06-01'),
  highlights: "Energetic · Fully vaccinated · Great with kids",
  booked: false,
  location: "Glasgow",
  user: user,
  photo_url: 'https://images.unsplash.com/photo-1534361960057-19889db9621e?w=500&auto=format&fit=crop'
)

create_pet(
  pet_name: 'Speckles',
  breed: 'Syrian Hamster',
  age: rand(1..3),
  size: 'Small',
  description: "Meet Speckles, the cutest little ball of energy you’ll ever see!",
  available_from: Date.parse('2025-05-18'),
  available_until: Date.parse('2025-06-08'),
  highlights: "House-trained · Low maintenance · Calm and gentle",
  booked: false,
  location: "Nottingham",
  user: user,
  photo_url: 'https://plus.unsplash.com/premium_photo-1721123258960-f095dff82bc7?w=500&auto=format&fit=crop'
)

puts "Pet 'Speckles' created and photo attached!"
  # rescue ActiveRecord::RecordInvalid => e
  #   puts "Pet creation failed: #{e.message}"
  # end

# Remove seeded bookings to rely on user-generated bookings only
puts "Seeding complete! Bookings are now user-generated."

# --------------------------------------------------------
