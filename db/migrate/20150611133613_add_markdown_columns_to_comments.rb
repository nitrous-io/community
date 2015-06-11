class AddMarkdownColumnsToComments < ActiveRecord::Migration
  def change
    add_column :comments, :content_html, :text
    add_column :comments, :content_text, :text
  end
end
