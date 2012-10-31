class BigboardsController < ApplicationController
  include Logic::Big_Board

  # display only for now
  def index
    @seasons = Season.all
  end

  def show
  	if params[:id].nil?
      # season_id not passed so show all seasons
      redirect_to seasons_path # back to index
    else
      @season = Season.find params[:id]

      @big_board = Big_Board_info.new(@season)
    end
  end
end
