class Doc < ActiveRecord::Base
  include FriendlyId
  include Likable
  include S3HttpsForceable
  include Markdownable
  include Publishable

  belongs_to :user
  belongs_to :doc_category

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  acts_as_taggable_on :tags
  friendly_id :title, use: :slugged

  scope :ordered, -> { order(position: :asc) }

  def self.grouped(columns=nil)
    if columns.present?
      columns = (columns.map(&:to_sym) + %i(id doc_category_id)).uniq
    end
    docs = (columns.blank? ? self : self.select(columns)).published.ordered.all
    categories = DocCategory.ordered.all
    h = ActiveSupport::OrderedHash.new
    categories.each do |c|
      h[c] = docs.select {|d| d.doc_category_id == c.id}
    end
    h
  end

  protected
  # To update slug when title get updated
  def should_generate_new_friendly_id?
    title_changed?
  end
end
