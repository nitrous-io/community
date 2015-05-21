class Post < ActiveRecord::Base
  include FriendlyId
  include Likable
  include Markdownable

  self.inheritance_column = :_type_disabled

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  friendly_id :title, use: :slugged
  acts_as_taggable_on :tags
end
