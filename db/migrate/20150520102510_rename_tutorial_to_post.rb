class RenameTutorialToPost < ActiveRecord::Migration
  def change
    remove_foreign_key :comments, column: :tutorial_id
    remove_foreign_key :likes, column: :tutorial_id

    rename_column :comments, :tutorial_id, :post_id
    rename_column :likes, :tutorial_id, :post_id

    add_foreign_key :comments, :posts
    add_foreign_key :likes, :posts
  end
end
