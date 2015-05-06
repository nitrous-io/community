class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :author
      t.references :tutorial, index: true
      t.text :content

      t.timestamps null: false
    end
    add_foreign_key :comments, :tutorials
  end
end
