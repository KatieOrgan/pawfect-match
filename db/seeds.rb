# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# Clear existing data
Booking.destroy_all
Pet.destroy_all
User.destroy_all

# Seed Users
10.times do
  begin
    User.create!(
      username: Faker::Internet.username,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: Faker::Internet.password(min_length: 8),
      profile_pic_url: "https://via.placeholder.com/150?unique=#{SecureRandom.uuid}",
      bio: Faker::Lorem.sentence,
      is_owner: [true, false].sample
    )
  rescue ActiveRecord::RecordInvalid => e
    puts "User creation failed: #{e.message}"
  end
end

Pet.create!(
  pet_name: 'Ziggy',
  breed: 'Springer Spaniel',
  age: rand(1..15),
  size: 'Medium',
  description: "Ziggy has wagging tail that never stops, always ready to greet everyone he meets like an old friend. His favorite thing in the world is going on long walks, where he sniffs every bush and trots happily by your side, making the whole neighborhood his fan club.",
  available: [true, false].sample,
  user_id: 1,
  pet_photo: 'https://unsplash.com/photos/a-brown-and-white-dog-sitting-on-top-of-a-table-goZLaBWGs2w'
)

Pet.create!(
  pet_name: 'Whiskers',
  breed: 'Dwarf Hamster',
  age: rand(1..5),
  size: 'Small',
  description: "Meet Whiskers, a hyperactive hamster who treats his wheel like a racetrack and insists on storing sunflower seeds in the most ridiculous places, like your shoes. He's got a knack for escaping his cage and showing up in unexpected spots, always leaving a trail of chaos and chewed-up cardboard behind him.",
  available: [true, false].sample,
  user_id: 1,
  pet_photo: 'https://unsplash.com/photos/white-and-yellow-chick-on-persons-hand--WXHMmc2RsY'
)

Pet.create!(
  pet_name: 'Slytherin',
  breed: 'Corn Snake',
  age: rand(1..20),
  size: 'Medium',
  description: "Slither is a mellow ball python who loves curling up in his favorite hide and lazily watching the world go by. While he's low-maintenance, he’ll need a sitter to keep his heat lamp on, his water fresh, and maybe even bravely offer him a thawed mouse or two!",
  available: [true, false].sample,
  user_id: 1,
  pet_photo: 'https://ugc.naturalatlas.com/photos/0/151/979/151979/tnT3a55o/1200.jpg?1627026957'
)

Pet.create!(
  pet_name: 'Dinky',
  breed: 'Tabby Cat',
  age: rand(1..20),
  size: 'Medium',
  description: "Luna is a fiercely independent tabby who spends her days lounging in sunbeams and silently judging your life choices from across the room. But every now and then, she’ll surprise you by hopping into your lap and demanding a hug, purring loudly as if to say, 'This doesn’t mean I need you… but don’t stop.'",
  available: [true, false].sample,
  user_id: 1,
  pet_photo: 'https://unsplash.com/photos/white-black-and-brown-cat-with-red-collar-4VnpYHSNQ7k'
)

Pet.create!(
  pet_name: 'Floppy',
  breed: 'Rex Rabbit',
  age: rand(1..20),
  size: 'Small',
  description: "Floppy is a curious little bunny with a soft, twitchy nose and a love for munching on fresh greens. He needs a sitter to keep his hay pile stocked, his water fresh, and to give him plenty of playtime and gentle ear rubs.",
  available: [true, false].sample,
  user_id: 1,
  pet_photo: 'https://unsplash.com/photos/white-and-brown-rabbit-kKAaCeGf5wY'
)

Pet.create!(
  pet_name: 'Noodle',
  breed: 'Sausage Dog',
  age: rand(1..12),
  size: 'Small',
  description: "Noodle is an energetic dachshund with a knack for sneaking treats when no one’s looking. He’ll need a sitter to take him on his beloved sniff-filled walks, keep his belly rub quota high, and make sure he doesn’t burrow into any forbidden blankets!",
  available: [true, false].sample,
  user_id: 1,
  pet_photo: 'https://unsplash.com/photos/brown-dachshund-puppy-on-green-grass-field-during-daytime-ohz49NaR9kM'
)

# Seed Pets
User.all.each do |user|
  rand(1..3).times do
    begin
      Pet.create!(
        pet_name: Faker::Creature::Dog.name,
        breed: Faker::Creature::Dog.breed,
        age: rand(1..15),
        size: %w[Small Medium Large].sample,
        description: Faker::Lorem.paragraph,
        available: [true, false].sample,
        user_id: user.id,
        pet_photo: "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8ZG9nfGVufDB8fDB8fHww" # Replace Faker::LoremFlickr.image for reliability
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Pet creation failed: #{e.message}"
    end
  end
end

# Remove seeded bookings to rely on user-generated bookings only
puts "Seeding complete! Bookings are now user-generated."
