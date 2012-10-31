class AddOutcomeToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :outcome, :integer, :default => -1

  end
end
