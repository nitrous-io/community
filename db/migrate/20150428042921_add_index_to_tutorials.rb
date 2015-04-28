class AddIndexToTutorials < ActiveRecord::Migration
  def change
    add_index :tutorials, :slug, unique: true
  end
end
