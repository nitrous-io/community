class AddLastFetchedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_fetched_at, :datetime, null: false
  end
end
