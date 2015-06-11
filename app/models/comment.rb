class Comment < ActiveRecord::Base
  include Markdownable

  belongs_to :parent, polymorphic: true
  belongs_to :user

  validates :content_markdown, :parent, presence: true
end
