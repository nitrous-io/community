class Tutorial < ActiveRecord::Base

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  # PrettyURL
  include FriendlyId
  friendly_id :title, use: :slugged

end
