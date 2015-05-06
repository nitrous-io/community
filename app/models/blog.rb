class Blog < ActiveRecord::Base
  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  include FriendlyId
  friendly_id :title, use: :slugged

  acts_as_taggable_on :tags
end
