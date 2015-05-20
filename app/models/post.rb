class Post < ActiveRecord::Base
  include FriendlyId

  self.inheritance_column = :_type_disabled

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, :content_markdown, presence: true
  validates :slug, uniqueness: true

  friendly_id :title, use: :slugged
  acts_as_taggable_on :tags

  before_save :set_html_from_markdown

  def set_html_from_markdown
    self.content_html = markdown.render(self.content_markdown)
  end

  protected
  def markdown
    @_markdown ||= begin
      renderer  = Redcarpet::Render::HTML.new({ filter_html: true, hard_wrap: true, prettify: true })
      Redcarpet::Markdown.new(renderer, { fenced_code_blocks: true, autolink: true, strikethrough: true })
    end
  end
end
