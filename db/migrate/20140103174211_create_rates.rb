class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.integer :user_id
      t.integer :score

      t.timestamps
    end
  end
end
