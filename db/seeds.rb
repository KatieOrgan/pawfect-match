# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# # Clear existing data
# Booking.destroy_all
# Pet.destroy_all
# User.destroy_all

# # Seed Users
# 10.times do
#   begin
#     User.create!(
#       username: Faker::Internet.username,
#       first_name: Faker::Name.first_name,
#       last_name: Faker::Name.last_name,
#       email: Faker::Internet.email,
#       password: Faker::Internet.password(min_length: 8),
#       profile_pic_url: "https://via.placeholder.com/150?unique=#{SecureRandom.uuid}",
#       bio: Faker::Lorem.sentence,
#       is_owner: [true, false].sample
#     )
#   rescue ActiveRecord::RecordInvalid => e
#     puts "User creation failed: #{e.message}"
#   end
# end

# # Seed Pets
# User.all.each do |user|
#   rand(1..3).times do
#     begin
#       Pet.create!(
#         pet_name: Faker::Creature::Dog.name,
#         breed: Faker::Creature::Dog.breed,
#         age: rand(1..15),
#         size: %w[Small Medium Large].sample,
#         description: Faker::Lorem.paragraph,
#         available: [true, false].sample,
#         user_id: user.id,
#         pet_photo: "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8ZG9nfGVufDB8fDB8fHww" # Replace Faker::LoremFlickr.image for reliability
#       )
#     rescue ActiveRecord::RecordInvalid => e
#       puts "Pet creation failed: #{e.message}"
#     end
#   end
# end

# # Remove seeded bookings to rely on user-generated bookings only
# puts "Seeding complete! Bookings are now user-generated."
#--------------------------------------------------------
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

ziggy = Pet.create!(
  pet_name: 'Ziggy',
  breed: 'Springer Spaniel',
  age: rand(1..15),
  size: 'Medium',
  description: "Ziggy has a wagging tail that never stops. His favorite thing in the world is going on long walks!",
  available: [true, false].sample,
  user: user
)

# Attach a photo via Active Storage
ziggy_photo_url = 'https://images.unsplash.com/photo-1723580729235-bc20921020e0?q=80&w=1374&auto=format&fit=crop'
ziggy_photo_file = URI.open(ziggy_photo_url)
ziggy.pet_photo.attach(
  io: ziggy_photo_file,
  filename: "ziggy.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Ziggy' created and photo attached!"

whiskers = Pet.create!(
  pet_name: 'Whiskers',
  breed: 'Dwarf Hamster',
  age: rand(1..5),
  size: 'Small',
  description: "Meet Whiskers, a hyperactive hamster who treats his wheel like a racetrack!",
  available: [true, false].sample,
  user: user
)

whiskers_photo_url = 'https://images.unsplash.com/photo-1622946377594-f0c462f11b20?q=80&w=1335&auto=format&fit=crop'
whiskers_file = URI.open(whiskers_photo_url)
whiskers.pet_photo.attach(
  io: whiskers_file,
  filename: "whiskers.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Whiskers' created and photo attached!"

# Slytherin
slytherin = Pet.create!(
  pet_name: 'Slytherin',
  breed: 'Corn Snake',
  age: rand(1..20),
  size: 'Medium',
  description: "Slither is a mellow ball python who loves curling up in his favorite hide and lazily watching the world go by. While he's low-maintenance, he’ll need a sitter to keep his heat lamp on, his water fresh, and maybe even bravely offer him a thawed mouse or two!",
  available: [true, false].sample,
  user_id: 1
)

slytherin_photo_url = 'https://ugc.naturalatlas.com/photos/0/151/979/151979/tnT3a55o/1200.jpg?1627026957'
slytherin_photo_file = URI.open(slytherin_photo_url)
slytherin.pet_photo.attach(
  io: slytherin_photo_file,
  filename: "slytherin.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Slytherin' created and photo attached!"

# Dinky
dinky = Pet.create!(
  pet_name: 'Dinky',
  breed: 'Tabby Cat',
  age: rand(1..5),
  size: 'Medium',
  description: "Luna is a fiercely independent tabby who spends her days lounging in sunbeams and silently judging your life choices from across the room. But every now and then, she’ll surprise you by hopping into your lap and demanding a hug, purring loudly as if to say, 'This doesn’t mean I need you… but don’t stop.'",
  available: [true, false].sample,
  user_id: 1
)

dinky_photo_url = 'https://images.unsplash.com/photo-1613467402748-2fe094a5cde0?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
dinky_photo_file = URI.open(dinky_photo_url)
dinky.pet_photo.attach(
  io: dinky_photo_file,
  filename: "dinky.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Dinky' created and photo attached!"

# Noodle
noodle = Pet.create!(
  pet_name: 'Noodle',
  breed: 'Sausage Dog',
  age: rand(1..8),
  size: 'Small',
  description: "Noodle is an energetic dachshund with a knack for sneaking treats when no one’s looking. He’ll need a sitter to take him on his beloved sniff-filled walks, keep his belly rub quota high, and make sure he doesn’t burrow into any forbidden blankets!",
  available: [true, false].sample,
  user_id: 1
)

noodle_photo_url = 'https://images.unsplash.com/photo-1621757298894-7174d1b1bc40?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
noodle_photo_file = URI.open(noodle_photo_url)
noodle.pet_photo.attach(
  io: noodle_photo_file,
  filename: "noodle.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Noodle' created and photo attached!"

# Floppy
floppy = Pet.create!(
  pet_name: 'Floppy',
  breed: 'Rex Rabbit',
  age: rand(1..10),
  size: 'Small',
  description: "Floppy is a curious little bunny with a soft, twitchy nose and a love for munching on fresh greens. He needs a sitter to keep his hay pile stocked, his water fresh, and to give him plenty of playtime and gentle ear rubs.",
  available: [true, false].sample,
  user_id: 1
)

floppy_photo_url = 'https://images.unsplash.com/photo-1535241749838-299277b6305f?q=80&w=1346&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
floppy_photo_file = URI.open(floppy_photo_url)
floppy.pet_photo.attach(
  io: floppy_photo_file,
  filename: "floppy.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Floppy' created and photo attached!"

#------

# Sid & Ralph
sid_and_ralph = Pet.create!(
  pet_name: 'Sid & Ralph',
  breed: 'Abyssinian Guinea Pigs',
  age: rand(1..8),
  size: 'Small',
  description: "TBC.",
  available: [true, false].sample,
  user_id: 1
)

sid_and_ralph_photo_url = 'https://images.unsplash.com/photo-1548767797-d8c844163c4c?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
sid_and_ralph_photo_file = URI.open(sid_and_ralph_photo_url)
sid_and_ralph.pet_photo.attach(
  io: sid_and_ralph_photo_file,
  filename: "sid_and_ralph.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Sid & Ralph' created and photo attached!"

# Paws
paws = Pet.create!(
  pet_name: 'Paws',
  breed: 'Persian Cat',
  age: rand(1..8),
  size: 'Small',
  description: "TBC",
  available: [true, false].sample,
  user_id: 1
)

paws_photo_url = 'https://images.unsplash.com/photo-1548366086-7f1b76106622?q=80&w=1352&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
paws_photo_file = URI.open(paws_photo_url)
paws.pet_photo.attach(
  io: paws_photo_file,
  filename: "paws.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Paws' created and photo attached!"

# Carly
carly = Pet.create!(
  pet_name: 'Carly',
  breed: 'Cockatiel',
  age: rand(1..10),
  size: 'Small',
  description: "TBC",
  available: [true, false].sample,
  user_id: 1
)

carly_photo_url = 'https://images.unsplash.com/photo-1458410489211-ba19aa2f2902?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YmlyZCUyMHBldHxlbnwwfHwwfHx8MA%3D%3D'
carly_photo_file = URI.open(carly_photo_url)
carly.pet_photo.attach(
  io: carly_photo_file,
  filename: "carly.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Carly' created and photo attached!"

# Caramel
caramel = Pet.create!(
  pet_name: 'Caramel',
  breed: 'American Fuzzy Lop Rabbit',
  age: rand(1..5),
  size: 'Small',
  description: "TBC.",
  available: [true, false].sample,
  user_id: 1
)

caramel_photo_url = 'https://images.unsplash.com/photo-1452857297128-d9c29adba80b?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
caramel_photo_file = URI.open(caramel_photo_url)
caramel.pet_photo.attach(
  io: caramel_photo_file,
  filename: "caramel.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Caramel' created and photo attached!"

# Pepe
pepe = Pet.create!(
  pet_name: 'Pepe',
  breed: 'Shihtzu Dog',
  age: rand(1..12),
  size: 'Small',
  description: "TBC",
  available: [true, false].sample,
  user_id: 1
)

pepe_photo_url = 'https://images.unsplash.com/photo-1534361960057-19889db9621e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
pepe_photo_file = URI.open(pepe_photo_url)
pepe.pet_photo.attach(
  io: pepe_photo_file,
  filename: "pepe.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Pepe' created and photo attached!"

# Speckles
speckles = Pet.create!(
  pet_name: 'Speckles',
  breed: 'Syrian Hamster',
  age: rand(1..3),
  size: 'Small',
  description: "TBC",
  available: [true, false].sample,
  user_id: 1
)

speckles_photo_url = 'https://plus.unsplash.com/premium_photo-1721123258960-f095dff82bc7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
speckles_photo_file = URI.open(speckles_photo_url)
speckles.pet_photo.attach(
  io: speckles_photo_file,
  filename: "speckles.jpg",
  content_type: "image/jpg"
)

puts "Pet 'Speckles' created and photo attached!"
  # rescue ActiveRecord::RecordInvalid => e
  #   puts "Pet creation failed: #{e.message}"
  # end

# Remove seeded bookings to rely on user-generated bookings only
puts "Seeding complete! Bookings are now user-generated."

# --------------------------------------------------------

# # Clear existing data
# Booking.destroy_all
# Pet.destroy_all
# User.destroy_all
# # Seed Users
# 1.times do
#   begin
#     User.create!(
#       username: "test",
#       first_name: Faker::Name.first_name,
#       last_name: Faker::Name.last_name,
#       email: Faker::Internet.email,
#       password: "123456",
#       profile_pic_url: "https://via.placeholder.com/150?unique=#{SecureRandom.uuid}",
#       bio: Faker::Lorem.sentence,
#       is_owner: [true, false].sample
#     )
#   rescue ActiveRecord::RecordInvalid => e
#     puts "User creation failed: #{e.message}"
#   end
# end
# # Seed Pets
# User.all.each do |user|
#   6.times do
#     begin
#       # Randomly assign a species
#       species = %w[Dog Cat Bird Rabbit].sample
#       # Generate relevant data based on species
#       case species
#       when "Dog"
#         pet_name = Faker::Creature::Dog.name
#         breed = Faker::Creature::Dog.breed
#         pet_photo = "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8ZG9nfGVufDB8fDB8fHww"
#       when "Cat"
#         pet_name = Faker::Creature::Cat.name
#         breed = Faker::Creature::Cat.breed
#         pet_photo = "https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8Y2F0fGVufDB8fDB8fHww"
#       when "Bird"
#         pet_name = Faker::Name.first_name # Birds don’t have specific name generators in Faker
#         breed = %w[Parrot Canary Finch Sparrow].sample
#         pet_photo = "https://images.unsplash.com/photo-1559582930-7c1f38468f31?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmlyZHxlbnwwfHwwfHx8MA"
#       when "Rabbit"
#         pet_name = Faker::Name.first_name
#         breed = %w[Holland_Lop Netherland_Dwarf Rex Lionhead].sample
#         pet_photo = "https://images.unsplash.com/photo-1582901600978-59d8fcb6f036?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmFiYml0fGVufDB8fDB8fHww"
#       end
#       # Create the pet
#       Pet.create!(
#         pet_name: pet_name,
#         breed: species,
#         age: rand(1..15),
#         size: %w[Small Medium Large].sample,
#         description: Faker::Lorem.paragraph,
#         available: [true, false].sample,
#         user_id: user.id,
#         pet_photo: pet_photo
#       )
#     rescue ActiveRecord::RecordInvalid => e
#       puts "Pet creation failed: #{e.message}"
#     end
#   end
# end
# # Remove seeded bookings to rely on user-generated bookings only
# puts "Seeding complete! Bookings are now user-generated."
