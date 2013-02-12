class MissedWeek < ActiveRecord::Base
  belongs_to :season, touch: true
  attr_accessible :season_id, :reason, :week_number, :holiday_date

  ## validations ##
  ## end validations ##

  ## functions ##
  ## end functions ##
end
