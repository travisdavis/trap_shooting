
class Array
  def swap!(a,b)
    self[a], self[b] = self[b], self[a]
    self
  end
end

class MatchesController < ApplicationController
  skip_before_filter :require_login

  def index
    @season = Season.find params[:season_id]
    @schedule = @season.get_schedule
  end

  def create
    # to build a schedule we need the number of teams
    season = Season.find params[:season_id]
    notice_message = "Schedule already exists."

    if season.matches.count == 0

      # deal with holidays first
      params[:holidays].split(" ").each do |holiday|
        season.missed_weeks.create(
          :reason => 'Holiday',
          :holiday_date => Date.strptime(holiday,'%m/%d/%Y'))
      end

      if params[:commit] == "Create standard schedule" && season.teams.count == 16
        schedule = season.create_Type1_schedule
      else
        schedule = season.create_schedule season.teams.count, false
      end

      # save the schedule in the DB
      for round in 0..(schedule.count)
        if schedule[round].nil?
          next
        end

        for match in 0..(schedule[round].count-1)
          teams = schedule[round][match].split(":")
          season.matches.create(
            :week_number => round+1,
            :slot => match,
            :first_team => Integer(teams[0]),
            :second_team => Integer(teams[1])
          )
        end
      end

      notice_message = "Schedule created."
    end

    redirect_to season_matches_path(:season_id => season.id), :notice => notice_message
  end
end
