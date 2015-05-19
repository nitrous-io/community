class Like < ActiveRecord::Base
  belongs_to :tutorial
  belongs_to :user

  validates :user_id, :tutorial_id, presence: true
end
