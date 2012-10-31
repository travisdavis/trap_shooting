class AddHandicapBirdsToResults < ActiveRecord::Migration
  def change
    add_column :results, :handicap_birds, :integer
  end
end
