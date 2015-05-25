class AddStateToPostsAndTutorials < ActiveRecord::Migration
  def change
    add_column :posts, :state, :integer, default: 0
    add_column :tutorials, :state, :integer, default: 0
  end
end
