class AddContentTextToTutorial < ActiveRecord::Migration
  def change
    add_column :tutorials, :content_text, :text
  end
end
