class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :micropost_id
      t.timestamps
    end
    add_index :attachments, :micropost_id
  end
end
