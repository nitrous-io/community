class Like < ActiveRecord::Base
  belongs_to :tutorial

  validates :user_id, :tutorial_id, presence: true
end
