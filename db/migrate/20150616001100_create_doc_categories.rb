class CreateDocCategories < ActiveRecord::Migration
  def change
    create_table :doc_categories do |t|
      t.string :name, null: false
      t.integer :position, default: 0, null: false

      t.timestamps null: false
    end

    add_index :doc_categories, :position
  end
end
