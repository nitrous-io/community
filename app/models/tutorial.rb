class Tutorial < ActiveRecord::Base

  validates :title, :content_markdown, :presence => true

end
