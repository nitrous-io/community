class Like < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :user_id, :parent, presence: true
end
