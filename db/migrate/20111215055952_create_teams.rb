class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :season_id
      t.integer :number
      t.string :name
      t.text :description
      t.integer :clean_up_week_number

      t.timestamps
    end
  end
end
