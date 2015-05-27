class AddParentToComment < ActiveRecord::Migration
  def change
    add_column :comments, :parent_id, :integer, null: false
    add_column :comments, :parent_type, :string, null: false
  end
end
