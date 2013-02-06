class NewbigBoardsController < ApplicationController
  skip_before_filter :require_login

  # display only for now
  def index
    @seasons = Season.all
  end

  def show
  	if params[:id].nil? or !params[:id].match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil
      # season_id not passed so show all seasons
      redirect_to newbig_boards_path # back to index
    else
      @season = Season.find params[:id]
    end
  end
end