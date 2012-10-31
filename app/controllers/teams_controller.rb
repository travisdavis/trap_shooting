class TeamsController < ApplicationController
  def index
    @season = Season.find params[:season_id]
    @teams = @season.teams.order(:number)
    @team = Team.new :season_id => @season.id
  end
  
  def create
    team = Team.new params[:team]

    if team.save
      redirect_to :back, :notice => 'Team Created.'
    else
      redirect_to :back, :notice => 'There was a problem creating the team.'
    end
  end
  
  def edit
    @team = Team.find params[:id]
  end
  
  def update
    team = Team.find params[:id]
    if team.update_attributes params[:team]
      redirect_to season_teams_path(:season_id => team.season_id), :notice => 'Team successfully updated.'
    else
      redirect_to :back, :notice => 'There was a problem updating the team.'
    end
  end

  def destroy
    team = Team.find params[:id]
    season_id = team.season_id
    team.destroy
    redirect_to season_teams_path(:season_id => season_id), :notice => 'Team has been deleted.'
  end
end
