class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.references :user, null: false
      t.references :doc_category, null: false

      t.string :slug,     null: false
      t.string :title,    null: false
      t.text :content_markdown, null: false
      t.text :content_html,     null: false
      t.text :content_text
      t.integer :score, default: 0
      t.integer :state, default: 0
      t.string :cover_image_url
      t.integer :position, default: 0, null: false

      t.datetime :published_at
      t.timestamps null: false
    end

    add_index :docs, :slug, unique: true
    add_index :docs, :doc_category_id
  end
end
