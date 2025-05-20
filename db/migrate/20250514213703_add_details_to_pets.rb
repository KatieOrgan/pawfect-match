class AddDetailsToPets < ActiveRecord::Migration[7.1]
  def change
    add_column :pets, :location, :string
    add_column :pets, :available_from, :date
    add_column :pets, :available_until, :date
    add_column :pets, :highlights, :text
    add_column :pets, :booked, :boolean, default: false
    add_column :pets, :latitude, :float
    add_column :pets, :longitude, :float
  end
end
