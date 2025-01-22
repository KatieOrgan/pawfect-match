class SetDefaultForIsOwnerInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :is_owner, from: nil, to: false
    change_column_null :users, :is_owner, false
  end
end
