class ShootersController < ApplicationController
  def index
    @team = Team.find params[:team_id]
    @season = Season.find @team.season_id
    @shooters = @team.shooters.order(:position)
    @shooter = Shooter.new :team_id => @team.id
  end

  def create
    shooter = Shooter.new params[:shooter]

    if shooter.save
      redirect_to :back, :notice => 'Shooter Created.'
    else
      redirect_to :back, :notice => 'There was a problem creating the shooter.'
    end
  end

  def edit
    @shooter = Shooter.find params[:id]
    @team = Team.find @shooter.team_id
  end
  
  def update
    shooter = Shooter.find params[:id]
    if shooter.update_attributes params[:shooter]
      redirect_to team_shooters_path(:team_id => shooter.team_id), :notice => 'Shooter successfully updated.'
    else
      redirect_to :back, :notice => 'There was a problem updating the Shooter.'
    end
  end
  
  def destroy
    shooter = Shooter.find params[:id]
    team_id = shooter.team_id
    shooter.destroy
    redirect_to team_shooters_path(:team_id => team_id), :notice => 'Shooter has been deleted.'
  end
end
