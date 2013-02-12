class SeasonsController < ApplicationController
  def index
    @season = Season.new #if there is an error on the page this will not repopulate the form
    @seasons = current_user.seasons
  end

  def create
    season = current_user.seasons.new params[:season]

    if season.save
      if params[:create_generic_teams_and_shooters] == "1"
        number_of_teams = params[:number_of_teams_to_create].to_i
        if number_of_teams > 0
          season.add_teams_and_shooters number_of_teams
        end
      end
      redirect_to :back, :notice => 'Season Created.'
    else
      redirect_to :back, :notice => 'There was a problem creating the season.'
    end
  end

  def edit
    @season = Season.find params[:id]
  end

  def update
    season = Season.find params[:id]
    week_number = params[:week_number]

    # we may be postponing a week
    if !week_number.nil?
      missed_week = season.missed_weeks.find_by_week_number(week_number)
      # only add the missed week if it is not already there
      if missed_week.nil?
        season.missed_weeks.create(
          :reason => 'Postponed', 
          :week_number => week_number)
      end

      redirect_to season_matches_path(:season_id => season.id), :notice => "Week #{week_number} has been postponed for season with id [#{season.id}]."
      return
    end

    if season.update_attributes params[:season]
      redirect_to seasons_path, :notice => 'Season successfully updated.'
    else
      redirect_to :back, :notice => 'There was a problem updating the season.'
    end
  end

  def destroy
    season = Season.find params[:id]
    season.destroy
    redirect_to :back, :notice => 'Season has been deleted.'
  end
end
