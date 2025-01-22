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

# Seed Bookings
User.all.each do |user|
  available_pets = Pet.where(available: true).sample(5)
  available_pets.each do |pet|
    begin
      Booking.create!(
        start_date: Faker::Date.between(from: Date.today, to: Date.today + 30),
        end_date: Faker::Date.between(from: Date.today + 31, to: Date.today + 60),
        status: %w[Pending Approved Declined].sample,
        user_id: user.id,
        pet_id: pet.id
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Booking creation failed: #{e.message}"
    end
  end
end

puts "Seeding complete!"
