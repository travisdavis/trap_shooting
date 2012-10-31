class AddCasperToShooters < ActiveRecord::Migration
  def change
    add_column :shooters, :casper, :boolean

  end
end
