class AddContentTextToPost < ActiveRecord::Migration
  def change
    add_column :posts, :content_text, :text
  end
end
