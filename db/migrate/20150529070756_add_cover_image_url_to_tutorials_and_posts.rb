class AddCoverImageUrlToTutorialsAndPosts < ActiveRecord::Migration
  def change
    add_column :posts, :cover_image_url, :string
    add_column :tutorials, :cover_image_url, :string
  end
end
