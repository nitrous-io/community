class AddParentToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :parent_id, :integer, null: false
    add_column :likes, :parent_type, :string, null: false
  end
end
