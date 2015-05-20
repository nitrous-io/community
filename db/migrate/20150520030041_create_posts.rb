class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.string :type
      t.string :slug
      t.string :title
      t.text :content_markdown
      t.text :content_html

      t.timestamps null: false
    end

    add_index :posts, :slug, unique: true
  end
end