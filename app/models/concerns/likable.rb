module Likable
  extend ActiveSupport::Concern

  included do
    has_many :likes, as: :parent, dependent: :destroy
  end

  def upvote(user_id)
    ActiveRecord::Base.transaction do
      like = self.likes.new(user_id: user_id)
      if like.save
        self.class.increment_counter(:score, self.id)
        return true
      end
    end
    false
  end

  def is_upvoted_by?(user_id)
    self.likes.where(user_id: user_id).exists?
  end
end