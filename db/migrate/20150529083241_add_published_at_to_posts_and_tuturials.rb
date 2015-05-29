class AddPublishedAtToPostsAndTuturials < ActiveRecord::Migration
  def change
    add_column :posts, :published_at, :datetime
    add_column :tutorials, :published_at, :datetime
  end
end
