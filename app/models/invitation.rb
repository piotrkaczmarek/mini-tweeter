class Invitation < ActiveRecord::Base
  belongs_to :organization
  belongs_to :user
  validates :organization_id, presence: true
  validates :user_id, presence: true
end
