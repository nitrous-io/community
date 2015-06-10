class Tutorial < ActiveRecord::Base
  include FriendlyId
  include Likable
  include Markdownable
  include Publishable
  include PgSearch

  belongs_to :user
  has_many :comments, as: :parent, dependent: :destroy

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  acts_as_taggable_on :tags
  friendly_id :title, use: :slugged

  pg_search_scope :search,
                  against: [:title, :content_markdown],
                  using: {
                      tsearch: {
                          dictionary: 'english'
                      },
                      trigram: {}
                  }

  scope :recently_updated, -> { order(updated_at: :desc)}

  protected
  # To update slug when title get updated
  def should_generate_new_friendly_id?
    title_changed?
  end
end
