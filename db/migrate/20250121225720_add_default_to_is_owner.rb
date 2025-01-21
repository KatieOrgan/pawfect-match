class AddDefaultToIsOwner < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :is_owner, false
  end
end
