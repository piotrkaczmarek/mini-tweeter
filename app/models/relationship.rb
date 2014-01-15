class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed_user, class_name: "User"
  belongs_to :followed_organization, class_name: "Organization"
  validates :follower_id, presence: true
  validates :followed_user_id, presence: true, if: :follows_user?
  validates :followed_organization_id, presence: true, if: :follows_organization?





  private

    def follows_user?
      self.followed_organization_id.blank?
    end

    def follows_organization?
      self.followed_user_id.blank?
    end

end
