class CreateUsers < ActiveRecord::Migration
  def change
    execute 'CREATE EXTENSION IF NOT EXISTS citext'
    create_table :users, id: false do |t|
      t.integer :id,                 null: false
      t.citext  :username,           null: false
      t.string  :email,              null: false
      t.string  :nitrous_oauth_token
      t.boolean :admin,              null: false, default: false
      t.timestamp
    end
  end
end
