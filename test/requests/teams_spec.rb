require 'spec_helper'

describe "Teams" do
  before do
    @season = Season.create(
      :name => 'Fall of 2011',
      :start_date => Date.new(2011,10,12,6),
      :houses => 4,
      :time_slots => 2,
      :handicap_calculation => 0.7,
      :description => 'Santa Ynez Valley Sportsman Association Fall 2011 Trap Shooting League'
    )
  end

  describe "GET /season_teams" do
    it "should ask user to create a team if none exist" do
      # there should be no teams
      visit season_teams_path :season_id => @season.id
      page.should have_content "Add a team using the form below"
    end

    it "creates a new team" do
      visit season_teams_path :season_id => @season.id
      
      # fill in the form
      fill_in 'Name', :with => 'Another Team'
      fill_in 'Number', :with => 2
      fill_in 'Clean up week number', :with => 2
      fill_in 'Description', :with => 'Another Team description goes here'
      
      click_button 'Create Team'
      
      current_path.should == season_teams_path(:season_id => @season.id)

      # notice value
      page.should have_content 'Team Created'
      
      # new seasons name
      page.should have_content 'Another Team'
    end

    it "will not create two teams with the same team number" do
      createTeamForSeason nil
      @team = @season.teams.first

      visit season_teams_path :season_id => @season.id

      # fill in the form
      fill_in 'Name', :with => 'Another Team'
      fill_in 'Number', :with => 1

      click_button 'Create Team'

      current_path.should == season_teams_path(:season_id => @team.season_id)

      # notice should be on the page
      page.should have_content 'There was a problem creating the team.'
    end

    it "display some teams" do
      createTeamForSeason nil
      @team = @season.teams.first

      visit season_teams_path :season_id => @season.id

      # verify season.name is on the page
      page.should have_content "Fall of 2011 Teams"

      # verify team number is on the page
      page.should have_content "Team 1"
    end

    it "links to Shooters" do
      createTeamForSeason nil
      @team = @season.teams.first
      visit season_teams_path(:season_id => @season.id)

      find("#team_#{@team.id}").click_link "#{@team.shooters.count}"

      current_path.should == team_shooters_path(:team_id => @team.id)
    end
  end

  describe "PUT /team" do
    it "edits a season" do
      createTeamForSeason nil
      @team = @season.teams.first

      visit season_teams_path :season_id => @season.id
      click_link 'Edit'

      current_path.should == edit_team_path(@team)

      find_field('Name').value.should == 'Team 1'

      fill_in 'Name', :with => 'updated team name'
      click_button 'Update Team'

      current_path.should == season_teams_path(:season_id => @team.season_id)

      # notice should be on the page
      page.should have_content 'Team successfully updated.'

      # updated season name should be on the page
      page.should have_content 'updated team name'
    end
    
    it "should not update an invalid team" do
      createTeamForSeason nil
      @team = @season.teams.first
      
      visit season_teams_path :season_id => @season.id
      click_link 'Edit'

      fill_in 'Name', :with => ''
      click_button 'Update Team'

      current_path.should == edit_team_path(@team)
      page.should have_content 'There was a problem updating the team.'
    end

    it "team number should be unique per season" do
      createTeamForSeason nil
      second_team = {
        :number => 2,
        :name => 'Team 2',
        :description => 'This team has some of the worst shooters in the league'
      }
      createTeamForSeason second_team

      visit season_teams_path :season_id => @season.id
      find("#team_#{@season.teams.second.id}").click_link 'Edit'

      fill_in 'Number', :with => "1"
      click_button 'Update Team'
      page.should have_content 'There was a problem updating the team.'
    end
  end

  describe "DELETE /team" do
    it "should delete a team" do 
      createTeamForSeason nil

      visit season_teams_path :season_id => @season.id
      click_link 'Delete'
      
      current_path.should == season_teams_path(:season_id => @season.id)
      page.should have_content 'Team has been deleted.'
    end
  end

  # helper function
  def createTeamForSeason(team)
    if team.nil?
      team = {
        :number => 1,
        :name => 'Team 1',
        :description => 'This team has some of the best shooters in the league'
      }
    end

    # add a team to the season
    @season.teams.create(team)
  end
end