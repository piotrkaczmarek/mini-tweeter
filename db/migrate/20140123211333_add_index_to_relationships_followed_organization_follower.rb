class AddIndexToRelationshipsFollowedOrganizationFollower < ActiveRecord::Migration
  def change
    add_index :relationships, :followed_organization_id
    add_index :relationships, [:follower_id, :followed_organization_id], unique: true
  end
end
