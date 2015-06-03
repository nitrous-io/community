module Publishable
  extend ActiveSupport::Concern

  included do
    enum state: [ :draft, :published, :deleted ]

    scope :published, -> { where(state: self.states[:published]).where('published_at < ?', Time.now) }
    scope :drafted, -> { where(state: self.states[:draft]) }
    scope :recently_published, -> { order(published_at: :desc)}
  end

  def publish_with!(attributes, published_at = nil)
    self.update_attributes(attributes.merge(state: :published, published_at: (published_at.blank? ? Time.now : published_at)))
  end

  def unpublish!
    self.update_attributes(state: :draft, published_at: nil)
  end
end