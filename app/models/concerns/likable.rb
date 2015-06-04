module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :parent, dependent: :destroy
  end

  def upvote(user_id)
    like = self.likes.new(user_id: user_id)
    # `counter_cache` does not update counter on memory. You need to re-fetch from database to get updated score
    # This is not to send unnecessary query to database
    if like.save
      self.score + 1
    else
      self.score
    end
  end

  def downvote(user_id)
    # `counter_cache` does not update counter on memory. You need to re-fetch from database to get updated score
    # This is not to send unnecessary query to database
    like = self.likes.find_by(user_id: user_id)
    if like
      like.destroy
      self.score - 1
    else
      self.score
    end
  end

  def is_upvoted_by?(user_id)
    self.likes.where(user_id: user_id).exists?
  end
end