class Tutorial < ActiveRecord::Base

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  # PrettyURL
  include FriendlyId
  friendly_id :title, use: :slugged

  # Stored in tag_list
  acts_as_taggable_on :tags

  has_many :comments, dependent: :destroy

end
