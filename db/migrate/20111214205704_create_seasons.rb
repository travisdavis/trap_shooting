class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.string :name
      t.datetime :start_date
      t.integer :houses
      t.integer :time_slots
      t.float :handicap_calculation
      t.text :description

      t.timestamps
    end
  end
end
