class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.references :tutorial, index: true

      t.timestamps null: false
    end
    add_foreign_key :likes, :tutorials
  end
end
