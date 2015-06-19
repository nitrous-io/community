class DocCategory < ActiveRecord::Base
  has_many :docs, dependent: :restrict_with_error

  scope :ordered, -> { order(position: :asc) }
end
