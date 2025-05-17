class RemoveBookedFromPets < ActiveRecord::Migration[7.1]
  def change
    remove_column :pets, :booked, :boolean
  end
end
