class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  belongs_to :organization

  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed_user

  has_many :reverse_relationships, foreign_key: "followed_user_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  has_many :followed_organizations, through: :relationships, source: :followed_organization

  before_save { self.email = self.email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: :validate_password?
  has_secure_password

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_and_organizations_followed_by(self)
  end

  def following?(other_user)
    hash = eval("{ followed_#{other_user.class.name.downcase}_id: #{other_user.id} }")
    relationships.find_by(hash)
  end

  def follow!(other_user)
    hash = eval("{ followed_#{other_user.class.name.downcase}_id: #{other_user.id} }")
    relationships.create!(hash)
  end

  def unfollow!(other_user)
    hash = eval("{ followed_#{other_user.class.name.downcase}_id: #{other_user.id} }")
    relationships.find_by(hash).destroy!
  end

  def add_to(organization)
    begin
      if organization
        self.disable_password_validation
        self.update_attributes(organization_id: organization.id)
        self.follow!(organization)
      else
        false
      end
    rescue
      false
    end
  end

  def remove_from_organization
    self.disable_password_validation
    self.update_attributes(organization_id: nil)
  end

  def is_admin_of?(organization)
    self.id == organization.admin_id
  end

  def disable_password_validation
    @dont_validate_password = true
  end

  def enable_password_validation
    @dont_validate_password = false
  end
  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

    def validate_password?
      !@dont_validate_password
    end
end
