class RenameContentToContentMarkdownInComments < ActiveRecord::Migration
  def change
    rename_column :comments, :content, :content_markdown
  end
end
