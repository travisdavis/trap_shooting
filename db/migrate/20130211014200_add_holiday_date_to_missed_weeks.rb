class AddHolidayDateToMissedWeeks < ActiveRecord::Migration
  def change
    add_column :missed_weeks, :holiday_date, :date
  end
end
