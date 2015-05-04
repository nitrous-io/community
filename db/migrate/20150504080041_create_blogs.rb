class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :author
      t.string :slug
      t.string :title
      t.text :content_markdown
      t.text :content_html

      t.timestamps null: false
    end
    add_index :blogs, :slug, unique: true
  end
end
