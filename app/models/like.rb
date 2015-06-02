class Like < ActiveRecord::Base
  belongs_to :parent, polymorphic: true, counter_cache: :score
  belongs_to :user

  validates :user_id, :parent, presence: true
  validates_uniqueness_of :user_id, scope: [:parent_id, :parent_type]
end
