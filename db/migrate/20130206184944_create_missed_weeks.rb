class CreateMissedWeeks < ActiveRecord::Migration
  def change
    create_table :missed_weeks do |t|
      t.integer :season_id
      t.integer :week_number
      t.string :reason

      t.timestamps
    end
  end
end
