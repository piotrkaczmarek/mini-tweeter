class ChangeRelationshipColumnFollowedIdToFollowedUserId < ActiveRecord::Migration
  def change
    rename_column :relationships, :followed_id, :followed_user_id
  end
end
