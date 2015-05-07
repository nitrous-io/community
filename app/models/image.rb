class Image < ActiveRecord::Base
  mount_uploader :file_name, ImageUploader

end
