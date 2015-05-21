class AddUserAndRemoveAuthorOnComments < ActiveRecord::Migration
  def change
    remove_column :comments, :author
    add_column :comments, :user_id, :integer, null: false
  end
end
