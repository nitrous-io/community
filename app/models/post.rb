class Post < ActiveRecord::Base
  include FriendlyId
  include Likable
  include Markdownable
  include Publishable

  belongs_to :user
  has_many :comments, as: :parent, dependent: :destroy

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  acts_as_taggable_on :tags
  friendly_id :title, use: :slugged

  scope :by_published_at, -> { order(published_at: :desc)}

  protected
  # To update slug when title get updated
  def should_generate_new_friendly_id?
    title_changed?
  end
end
