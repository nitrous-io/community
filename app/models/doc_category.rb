class DocCategory < ActiveRecord::Base
  scope :ordered, -> { order(position: :asc) }
end
