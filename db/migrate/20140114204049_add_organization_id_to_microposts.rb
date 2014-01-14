class AddOrganizationIdToMicroposts < ActiveRecord::Migration
  def change
    add_column :microposts, :organization_id, :integer
  end
end
