class AddIndexesOnStateAndPublishedAt < ActiveRecord::Migration
  def change
    add_index :posts, [:state, :published_at]
    add_index :tutorials, [:state, :published_at]
    add_index :docs, [:state, :published_at]
  end
end
