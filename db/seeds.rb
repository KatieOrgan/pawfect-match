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
        pet_photo: "https://via.placeholder.com/300" # Replace Faker::LoremFlickr.image for reliability
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Pet creation failed: #{e.message}"
    end
  end
end

# Remove seeded bookings to rely on user-generated bookings only
puts "Seeding complete! Bookings are now user-generated."
