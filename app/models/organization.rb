class Organization < ActiveRecord::Base
  has_one :admin, class_name: "User"
  has_many :members, class_name: "User"
  has_many :microposts


  has_many :organization_reverse_relationships, foreign_key: "followed_organization_id",
                                                class_name: "Relationship",
                                                dependent: :destroy
  has_many :followers, through: :organization_reverse_relationships, source: :follower

  validates :name, presence: true, length: { maximum: 50 }
  validates :admin_id, presence: true
end
