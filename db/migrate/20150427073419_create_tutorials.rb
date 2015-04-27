class CreateTutorials < ActiveRecord::Migration
  def change
    create_table :tutorials do |t|
      t.integer :user_id
      t.boolean :admin
      t.string :author
      t.string :slug
      t.string :title
      t.text :content_markdown
      t.text :content_html
      t.boolean :approved

      t.timestamps null: false
    end
  end
end
