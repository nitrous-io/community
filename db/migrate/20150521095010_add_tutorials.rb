class AddTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.references :user, null: false
      t.string :slug, null: false
      t.string :title, null: false
      t.text :content_markdown, null: false
      t.text :content_html, null: false
      t.integer :score, default: 0

      t.timestamps null: false
    end
    add_index :tutorials, :slug, unique: true
  end
end
