class AddIsBlindScoreToResults < ActiveRecord::Migration
  def change
    add_column :results, :is_blind_score, :boolean, :default => false

  end
end
