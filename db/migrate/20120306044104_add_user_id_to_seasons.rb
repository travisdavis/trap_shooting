class AddUserIdToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :user_id, :integer

  end
end
