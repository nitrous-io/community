class Tutorial < ActiveRecord::Base
  include FriendlyId
  include Likable
  include Markdownable

  belongs_to :user
  has_many :comments, as: :parent, dependent: :destroy

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  friendly_id :title, use: :slugged
  acts_as_taggable_on :tags
end
