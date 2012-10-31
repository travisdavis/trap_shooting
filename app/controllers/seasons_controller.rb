class SeasonsController < ApplicationController
  def index
    @season = Season.new #if there is an error on the page this will not repopulate the form
    @seasons = Season.all
  end

  def create
    season = Season.new
    
    if season.update_attributes params[:season]
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
