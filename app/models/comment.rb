class Comment < ActiveRecord::Base
  belongs_to :tutorial

  validates :content, presence: true
end
