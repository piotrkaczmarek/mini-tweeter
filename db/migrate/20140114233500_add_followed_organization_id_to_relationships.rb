class AddFollowedOrganizationIdToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :followed_organization_id, :integer
  end
end
