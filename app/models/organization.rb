class Organization < ActiveRecord::Base
  has_one :admin, class_name: "User"
  has_many :members, class_name: "User"
  has_many :microposts, through: :members

  validates :name, presence: true, length: { maximum: 50 }
  validates :admin_id, presence: true
end
