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
1.times do
  begin
    User.create!(
      username: "test",
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: "123456"
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
  6.times do
    begin
      # Randomly assign a species
      species = %w[Dog Cat Bird Rabbit].sample

      # Generate relevant data based on species
      case species
      when "Dog"
        pet_name = Faker::Creature::Dog.name
        breed = Faker::Creature::Dog.breed
        pet_photo = "https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8ZG9nfGVufDB8fDB8fHww"
      when "Cat"
        pet_name = Faker::Creature::Cat.name
        breed = Faker::Creature::Cat.breed
        pet_photo = "https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8Y2F0fGVufDB8fDB8fHww"
      when "Bird"
        pet_name = Faker::Name.first_name # Birds don’t have specific name generators in Faker
        breed = %w[Parrot Canary Finch Sparrow].sample
        pet_photo = "https://images.unsplash.com/photo-1559582930-7c1f38468f31?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmlyZHxlbnwwfHwwfHx8MA"
      when "Rabbit"
        pet_name = Faker::Name.first_name
        breed = %w[Holland_Lop Netherland_Dwarf Rex Lionhead].sample
        pet_photo = "https://images.unsplash.com/photo-1582901600978-59d8fcb6f036?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cmFiYml0fGVufDB8fDB8fHww"
      end

      # Create the pet
      Pet.create!(
        pet_name: pet_name,
        species: species,
        breed: breed,
        age: rand(1..15),
        size: %w[Small Medium Large].sample,
        description: Faker::Lorem.paragraph,
        available: [true, false].sample,
        user_id: user.id,
        pet_photo: pet_photo
      )
    rescue ActiveRecord::RecordInvalid => e
      puts "Pet creation failed: #{e.message}"
    end
  end
end

# Remove seeded bookings to rely on user-generated bookings only
puts "Seeding complete! Bookings are now user-generated."
