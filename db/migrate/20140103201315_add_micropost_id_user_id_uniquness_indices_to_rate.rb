class AddMicropostIdUserIdUniqunessIndicesToRate < ActiveRecord::Migration
  def change
    add_index :rates, :micropost_id
    add_index :rates, [:micropost_id,:user_id], unique: true
  end
end
