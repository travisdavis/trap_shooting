class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :match_id
      t.integer :shooter_id
      t.integer :sixteen_yards
      t.integer :handicap

      t.timestamps
    end
  end
end
