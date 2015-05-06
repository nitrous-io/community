class AddScoreToTutorials < ActiveRecord::Migration
  def change
    add_column :tutorials, :score, :integer, default: 0
  end
end
