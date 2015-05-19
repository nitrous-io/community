class User < ActiveRecord::Base
  self.primary_key = 'id'

  validates :username, presence: true
end
