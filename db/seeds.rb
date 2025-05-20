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
  pet = Pet.new(attributes.except(:photo_urls))
  pet.geocode
  pet.save!

  if attributes[:photo_urls].present?
    attributes[:photo_urls].first(5).each_with_index do |url, index|
      begin
        file = URI.open(url)
        pet.pet_photos.create!(
          position: index,
          image: {
            io: file,
            filename: "photo#{index + 1}.jpg",
            content_type: "image/jpeg"
          }
        )
      rescue => e
        puts "Failed to attach photo #{index + 1} for #{pet.pet_name}: #{e.message}"
      end
    end
  end

  puts "Pet '#{pet.pet_name}' created with #{pet.pet_photos.count} photo(s) and geocoded!"
end



create_pet(
  pet_name: 'Ziggy',
  animal_type: 'Dog',
  breed: 'Springer Spaniel',
  age: rand(1..15),
  size: 'Medium',
  description: "Ziggy has a wagging tail that never stops. His favorite thing in the world is going on long walks!",
  available_from: Date.today + rand(1..10),
  available_until: Date.today + rand(20..40),
  highlights: "Great with kids · Loves long walks · Very cuddly",
  location: "Leeds",
  user: user,
  photo_urls: [
    'https://images.unsplash.com/photo-1723580729235-bc20921020e0?q=80&w=1374&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop',
    'https://images.unsplash.com/photo-1525253086316-d0c936c814f8?auto=format&fit=crop'
  ]  
)

create_pet(
  pet_name: 'Whiskers',
  animal_type: 'Hamster',
  breed: 'Dwarf Hamster',
  age: rand(1..5),
  size: 'Small',
  description: "Meet Whiskers, a hyperactive hamster who treats his wheel like a racetrack!",
  available_from: Date.parse('2025-05-16'),
  available_until: Date.parse('2025-06-07'),
  highlights: "Low maintenance · House-trained · Great with kids",
  location: "York",
  user: user,
  photo_urls: [
    'https://images.unsplash.com/photo-1721327900409-5e445c1ed119?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1721327900411-b315dce4388e?q=80&w=3526&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1452721226468-f95fb66ebf83?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1721327900409-2393c686bc48?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ]
  
)

create_pet(
  pet_name: 'Slytherin',
  animal_type: 'Reptile',
  breed: 'Corn Snake',
  age: rand(1..20),
  size: 'Medium',
  description: "Slither is a mellow ball python who loves curling up in his favorite hide and lazily watching the world go by.",
  available_from: Date.parse('2025-05-19'),
  available_until: Date.parse('2025-06-13'),
  highlights: "Great with kids · Fully vaccinated · Calm and gentle",
  location: "Bristol",
  user: user,
  photo_urls: [
    'https://images.unsplash.com/photo-1729072986528-6baac79be36e?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1725696832679-b10c1ea887ac?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1611910850739-2dc7e5d67a66?q=80&w=2765&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ]
    )

create_pet(
  pet_name: 'Dinky',
  animal_type: 'Cat',
  breed: 'Tabby Cat',
  age: rand(1..5),
  size: 'Medium',
  description: "Luna is a fiercely independent tabby who spends her days lounging in sunbeams and silently judging your life choices.",
  available_from: Date.parse('2025-05-18'),
  available_until: Date.parse('2025-06-11'),
  highlights: "Low maintenance · Great with kids · Fully vaccinated",
  location: "Leeds",
  user: user,
  photo_urls: [
    'https://images.unsplash.com/photo-1733111658376-e55515046085?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1733111327871-1af2d3838968?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1733111280187-fb53835b77d0?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1733111591757-0e4570d369ab?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1733111626698-2f8fee97323e?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ]
    )

create_pet(
  pet_name: 'Noodle',
  animal_type: 'Dog',
  breed: 'Sausage Dog',
  age: rand(1..8),
  size: 'Small',
  description: "Noodle is an energetic dachshund with a knack for sneaking treats when no one’s looking.",
  available_from: Date.parse('2025-05-18'),
  available_until: Date.parse('2025-06-03'),
  highlights: "Playful · Fully vaccinated · Calm and gentle",
  location: "Manchester",
  user: user,
  photo_urls: [
    'https://images.unsplash.com/photo-1681917961077-ae09aa67061d?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1681917920001-d4934319da30?q=80&w=3748&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1681917896245-bb6c689e58b4?q=80&w=3939&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1618265341355-d0e2d1fdf26b?q=80&w=3495&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ]
    )

create_pet(
  pet_name: 'Floppy',
  animal_type: 'Rabbit',
  breed: 'Rex Rabbit',
  age: rand(1..10),
  size: 'Small',
  description: "Floppy is a curious little bunny with a soft, twitchy nose and a love for munching on fresh greens.",
  available_from: Date.parse('2025-05-14'),
  available_until: Date.parse('2025-06-06'),
  highlights: "Calm and gentle · Fully vaccinated · House-trained",
  location: "Cambridge",
  user: user,
  photo_urls: [
    'https://images.unsplash.com/photo-1452857297128-d9c29adba80b?q=80&w=2560&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1619447257726-fe312296ee9b?q=80&w=3088&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1559214369-a6b1d7919865?q=80&w=3067&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ]
    )

create_pet(
  pet_name: 'Sid & Ralph',
  animal_type: 'Guinea Pig',
  breed: 'Abyssinian Guinea Pigs',
  age: rand(1..8),
  size: 'Small',
  description: "Meet the dynamic duo, Sid and Ralph, two brother guinea pigs with hearts as big as their appetites!",
  available_from: Date.parse('2025-05-17'),
  available_until: Date.parse('2025-06-01'),
  highlights: "Low maintenance · Great with kids · Energetic",
  location: "Sheffield",
  user: user,
  photo_urls: ['https://images.unsplash.com/photo-1548767797-d8c844163c4c?q=80&w=1171&auto=format&fit=crop',
               'https://images.unsplash.com/photo-1526346093155-a601c2cbe917?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
               'https://images.unsplash.com/photo-1548767782-3e3135d4725b?q=80&w=2671&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
               'https://images.unsplash.com/photo-1655065127332-ae390f338bb4?q=80&w=2632&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
              ]
)

create_pet(
  pet_name: 'Paws',
  animal_type: 'Cat',
  breed: 'Persian Cat',
  age: rand(1..8),
  size: 'Small',
  description: "Meet Paws, a fluffy ball of charm with a purr that can melt anyone’s heart.",
  available_from: Date.parse('2025-05-21'),
  available_until: Date.parse('2025-06-06'),
  highlights: "Calm and gentle · Fully vaccinated · Playful",
  location: "Newcastle",
  user: user,
  photo_urls: ['https://images.unsplash.com/photo-1548366086-7f1b76106622?q=80&w=1352&auto=format&fit=crop',
               'https://images.unsplash.com/photo-1585137173132-cf49e10ad27d?q=80&w=2572&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
               'https://images.unsplash.com/photo-1591429939960-b7d5add10b5c?q=80&w=2572&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
              ]
  )

create_pet(
  pet_name: 'Carly',
  animal_type: 'Bird',
  breed: 'Cockatiel',
  age: rand(1..10),
  size: 'Small',
  description: "Meet Carly, the sweetest little cockatiel with a heart full of song and feathers full of personality!",
  available_from: Date.parse('2025-05-17'),
  available_until: Date.parse('2025-06-09'),
  highlights: "Loves cuddles · Great with kids · Energetic",
  location: "Birmingham",
  user: user,
  photo_urls: ['https://images.unsplash.com/photo-1458410489211-ba19aa2f2902?w=500&auto=format&fit=crop',
               'https://images.unsplash.com/photo-1615827453817-128e639ba2cf?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
               'https://images.unsplash.com/photo-1658837345115-e22db41aafff?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
              ]
)

create_pet(
  pet_name: 'Caramel',
  animal_type: 'Rabbit',
  breed: 'American Fuzzy Lop Rabbit',
  age: rand(1..5),
  size: 'Small',
  description: "Meet Caramel, the fluffiest bundle of joy you’ll ever meet!",
  available_from: Date.parse('2025-05-14'),
  available_until: Date.parse('2025-06-03'),
  highlights: "Playful · House-trained · Great with kids",
  location: "Cardiff",
  user: user,
  photo_urls: ['https://images.unsplash.com/photo-1705587226131-dd57b0c426b7?q=80&w=2415&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1705832291614-aaeb8ef8740c?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1705832291598-96df7e088a35?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1705832291581-a117defd99c5?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
            ]
  )

create_pet(
  pet_name: 'Pepe',
  animal_type: 'Dog',
  breed: 'Shihtzu Dog',
  age: rand(1..12),
  size: 'Small',
  description: "This sweet Shih Tzu may be small, but he’s got a personality that fills the room.",
  available_from: Date.parse('2025-05-14'),
  available_until: Date.parse('2025-06-01'),
  highlights: "Energetic · Fully vaccinated · Great with kids",
  location: "Glasgow",
  user: user,
  photo_urls: ['https://images.unsplash.com/photo-1534361960057-19889db9621e?w=500&auto=format&fit=crop',
  'https://images.unsplash.com/photo-1619736163418-0826329731fe?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1592170358450-782ca09fb657?q=80&w=2574&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
          ]
)

create_pet(
  pet_name: 'Speckles',
  animal_type: 'Hamster',
  breed: 'Syrian Hamster',
  age: rand(1..3),
  size: 'Small',
  description: "Meet Speckles, the cutest little ball of energy you’ll ever see!",
  available_from: Date.parse('2025-05-18'),
  available_until: Date.parse('2025-06-08'),
  highlights: "House-trained · Low maintenance · Calm and gentle",
  location: "Nottingham",
  user: user,
  photo_urls: ['https://images.unsplash.com/photo-1618232118117-98d49b20e2f5?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1657399621130-67f3e1bd8da7?q=80&w=2670&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1738486310307-d2982bd995e6?q=80&w=2680&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
        ]
)

puts "Pet 'Speckles' created and photo attached!"
  # rescue ActiveRecord::RecordInvalid => e
  #   puts "Pet creation failed: #{e.message}"
  # end

# Remove seeded bookings to rely on user-generated bookings only
puts "Seeding complete! Bookings are now user-generated."

# --------------------------------------------------------
