class AddMicropostIdToRate < ActiveRecord::Migration
  def change
    add_column :rates, :micropost_id, :integer
  end
end
