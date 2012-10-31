class ResultsController < ApplicationController
  include Logic::Results

  def index
    @match = Match.find params[:match_id]

    first_team = Team.where(:season_id => @match.season_id, :number => @match.first_team).first
    first_team_info = Team_info.new(first_team, @match.id)
    #stash the team totals and create an array of shooters and their results
    @first_team_results = first_team_info.get_shooters_results
    @first_team_total = first_team_info.total;

    second_team = Team.where(:season_id => @match.season_id, :number => @match.second_team).first
    second_team_info = Team_info.new(second_team, @match.id)
    #stash the team totals and create an array of shooters and their results
    @second_team_results = second_team_info.get_shooters_results
    @second_team_total = second_team_info.total

    # team totals cannot be zero
    if first_team_info.has_all_results_reported && second_team_info.has_all_results_reported
      # update the match outcome if needed
      match_outcome = @match.outcome
      if @first_team_total > @second_team_total
        match_outcome = 1 #OUTCOME_FIRST_TEAM_WIN
      elsif @first_team_total < @second_team_total
        match_outcome = 2 #OUTCOME_SECOND_TEAM_WIN
      else
        match_outcome = 0 #OUTCOME_TIE
      end

      if @match.outcome != match_outcome
        @match.outcome = match_outcome
        @match.save
      end
    end
    @match_banner = "#{@match.get_text_for_schedule}"
  end

  def new
    @match = Match.find params[:match_id]
    @result = Result.new(:match_id => @match.id, :shooter_id => params[:shooter_id])
    @shooter = Shooter.find @result.shooter_id
  end

  def create
    result = Result.new params[:result]

    if result.save
      redirect_to match_results_path(:match_id => result.match_id), :notice => 'Result Created.'
    else
      redirect_to :back, :notice => 'There was a problem creating the result.'
    end
  end

  def edit
    @result = Result.find params[:id]
    @match = Match.find @result.match_id
    @shooter = Shooter.find @result.shooter_id
  end

  def update
    result = Result.find params[:id]

    if result.update_attributes(params[:result])
      redirect_to match_results_path :match_id => result.match_id, :notice => 'Result successfully updated.'
    else
      redirect_to :back, :notice => 'There was a problem updating the result.'
    end
  end
end
