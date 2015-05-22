class User < ActiveRecord::Base
  self.primary_key = 'id'

  has_many :likes, dependent: :destroy
  validates :username, presence: true
  before_save :set_email_md5

  def outdated?
    self.last_fetched_at < 1.day.ago
  end

  protected
  def set_email_md5
    self.email_md5 = Digest::MD5.hexdigest(self.email)
  end
end
