class Image < ActiveRecord::Base
  mount_uploader :file_name, ImageUploader

  validates :file_name, presence: true
end
