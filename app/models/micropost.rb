class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :rates, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  before_validation :clear_rating
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :rating, inclusion: { in: 0.0..5.0}, allow_nil: true
  validates :rated_by, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
           user_id: user.id)
  end

  def rate_it(user_id,score)
    @rate = rates.find_by_user_id(user_id)
    if @rate
      change_rate(user_id,score)
    else
      add_rate(user_id,score)
    end
  end
  def add_rate(user_id,score)
    clear_rating
    sum_score = self.rating * self.rated_by

    rate = self.rates.build(user_id: user_id, micropost_id: self.id, score: score)
    self.rated_by += 1
    sum_score += score

    self.rating = sum_score/self.rated_by
    return rate
  end
  def change_rate(user_id,score)
    sum_score = rates.sum(:score) 
    sum_score += score - @rate.score
    @rate.score = score
    self.rating = sum_score/rated_by
    return @rate
  end
  def answer_to
    Micropost.find_by_id(self.answer_to_id)
  end
  def answered? 
    if Micropost.find_by_answer_to_id(self.id)
      true
    else
      false
    end
  end
  private
      def clear_rating
        if self.rated_by == nil
          self.rated_by = 0
          self.rating = 0.0
        end
      end

end
