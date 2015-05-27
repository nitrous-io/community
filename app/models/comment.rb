class Comment < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :content, :parent, presence: true
end
