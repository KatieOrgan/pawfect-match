class CreatePetPhotos < ActiveRecord::Migration[7.1]
  def change
    create_table :pet_photos do |t|
      t.references :pet, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
