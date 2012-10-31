class CreateShooters < ActiveRecord::Migration
  def change
    create_table :shooters do |t|
      t.integer :team_id
      t.integer :position
      t.string :name
      t.integer :handicap_yardage
      t.text :description

      t.timestamps
    end
  end
end
