class CreatePets < ActiveRecord::Migration[7.1]
  def change
    create_table :pets do |t|
      t.string :pet_name
      t.string :breed
      t.integer :age
      t.string :size
      t.string :description
      t.boolean :available
      t.string :pet_photo
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
