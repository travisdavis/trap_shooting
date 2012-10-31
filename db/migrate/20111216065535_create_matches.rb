class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :season_id
      t.integer :week_number
      t.integer :first_team
      t.integer :second_team
      t.integer :slot

      t.timestamps
    end
  end
end
