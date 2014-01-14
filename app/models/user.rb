class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  belongs_to :organization
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed_user
  has_many :reverse_relationships, foreign_key: "followed_user_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
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
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_user_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_user_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_user_id: other_user.id).destroy!
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
