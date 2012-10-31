class DeleteHandicapBirdsFromResults < ActiveRecord::Migration
  def up
  	remove_column :results, :handicap_birds
  end

  def down
  	add_column :results, :handicap_birds, :integer
  end
end
