class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :organization_id
      t.integer :user_id

      t.timestamps
    end
    add_index :invitations, :organization_id
    add_index :invitations, :user_id
    add_index :invitations, [:organization_id, :user_id], unique: true
  end
end
