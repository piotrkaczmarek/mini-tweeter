class Attachment < ActiveRecord::Base
  belongs_to :micropost
  has_attached_file :file

end
