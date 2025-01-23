class RemoveOldColumnsFromUsersAndPets < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :profile_pic_url, :string
    remove_column :pets, :pet_photo, :string
  end
end
