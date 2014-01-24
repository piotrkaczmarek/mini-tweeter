class Organization < ActiveRecord::Base
  has_one :admin, class_name: "User"
  has_many :members, class_name: "User"
  has_many :microposts
  has_many :organization_reverse_relationships, foreign_key: "followed_organization_id",
                                                class_name: "Relationship",
                                                dependent: :destroy
  has_many :followers, through: :organization_reverse_relationships, source: :follower

  has_many :invitations, foreign_key: "organization_id", class_name: "Invitation",
                         dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user

  validates :name, presence: true, length: { maximum: 50 }
  validates :admin_id, presence: true

  def invite(user)
    if (not already_invited?(user)) and (not already_member?(user))
      self.invitations.create(user_id: user.id) 
    end  
  end

  private

    def already_invited? user
      not Invitation.where(user_id: user.id, organization_id: self.id).empty?
    end

    def already_member? user
      user.organization_id == self.id
    end

end
