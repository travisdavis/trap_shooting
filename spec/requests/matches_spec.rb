require 'spec_helper'

describe "Matches" do
  before do
    @season = Season.create(
      :name => 'Fall of 2011',
      :start_date => Date.new(2011,10,12,6),
      :houses => 4,
      :time_slots => 2,
      :handicap_calculation => 0.7,
      :description => 'Santa Ynez Valley Sportsman Association Fall 2011 Trap Shooting League'
    )
    @season.teams.create({
      :number => 1,
      :name => 'Team 1',
      :description => 'This team has some of the best shooters in the league'
    })
    @season.teams.create({
      :number => 2,
      :name => 'Team 2',
      :description => 'This team has some of the worst shooters in the league'
    })
  end

  describe "GET /season_matches" do
    it "should ask user to create a matches if none exist" do
      visit season_matches_path :season_id => @season.id
      page.should have_button "Create Schedule"
    end

    it "should display some matches" do
      createMatchForSeason nil
      @match = @season.matches.first

      visit season_matches_path :season_id => @season.id

      # verify season.name is on the page
      page.should have_content "Fall of 2011 matches"

      # verify team number is on the page
      page.should have_content "1 vs 2"
    end

    it "should show the result of the match if all shooters have shot" do
      createMatchForSeason nil
      @match = @season.matches.first

      # add shooters
      first_team = Team.find_by_number @match.first_team
      # add five shooters
      for shooter_position in (1..5) do
        first_team.shooters.create(
          :position => shooter_position,
          :name => "Shooter #{shooter_position}",
          :handicap_yardage => 27,
          :description => "Shooter #{shooter_position} description goes here"
        )
      end
      second_team = Team.find_by_number @match.second_team
      # add five shooters
      for shooter_position in (1..5) do
        second_team.shooters.create(
          :position => shooter_position,
          :name => "Shooter #{shooter_position}",
          :handicap_yardage => 27,
          :description => "Shooter #{shooter_position} description goes here"
        )
      end

      visit season_matches_path :season_id => @season.id
      find("#match_#{@match.id}").click_link '1 vs 2'

      current_path.should == match_results_path(:match_id => @match.id)
      page.should have_content "1 vs 2"

      # add results for the first team
      # first pass will be a tie
      first_team_total = 0
      for shooter in first_team.shooters

        find("#shooter_#{shooter.id}").click_link "Add results"

        fill_in 'Sixteen yards', :with => 20
        fill_in 'Handicap', :with => 20

        first_team_total += 47

        click_button 'Create Result'
        current_path.should == match_results_path(:match_id => @match.id)

        shooter_row_dom = find("#shooter_#{shooter.id} td.total_hit")
        shooter_row_dom.should have_content "47"

        find("#first_team td.team_total").should have_content "Total: #{first_team_total}"
      end

      second_team_total = 0
      second_team_last_shooter_id = -1
      for shooter in second_team.shooters
        find("#shooter_#{shooter.id}").click_link "Add results"

        fill_in 'Sixteen yards', :with => 20
        fill_in 'Handicap', :with => 20

        second_team_total += 47

        click_button 'Create Result'
        current_path.should == match_results_path(:match_id => @match.id)

        shooter_row_dom = find("#shooter_#{shooter.id} td.total_hit")
        shooter_row_dom.should have_content "47"

        find("#second_team td.team_total").should have_content "Total: #{second_team_total}"
        second_team_last_shooter_id = shooter.id
      end

      current_path.should == match_results_path(:match_id => @match.id)
      page.should have_content "1 tied 2"

      # update the second team's first shooter to have 20 at sixteen yards
      find("#shooter_#{second_team_last_shooter_id}").click_link "Edit"

      fill_in 'Sixteen yards', :with => 15
      click_button 'Update Result'

      current_path.should == match_results_path(:match_id => @match.id)
      page.should have_content "1 beat 2"

      # update the second team's first shooter to have 20 at sixteen yards
      find("#shooter_#{second_team_last_shooter_id}").click_link "Edit"

      fill_in 'Sixteen yards', :with => 25
      click_button 'Update Result'

      current_path.should == match_results_path(:match_id => @match.id)
      page.should have_content "1 loss 2"
    end

    it "should display the winner" do
      createMatchForSeason nil
      @match = @season.matches.first

      @match.outcome.should eq(-1)

      # set the outcome on the match
      @match.outcome = 1 # first team is the winner
      @match.save

      @match.outcome.should eq(1)
      visit season_matches_path :season_id => @season.id
      page.should have_content "1 beat 2"

      # set the outcome on the match
      @match.outcome = 2 # first team is the winner
      @match.save

      @match.outcome.should eq(2)
      visit season_matches_path :season_id => @season.id
      page.should have_content "1 loss 2"

      # set the outcome on the match
      @match.outcome = 0 # tie
      @match.save

      @match.outcome.should eq(0)
      visit season_matches_path :season_id => @season.id
      page.should have_content "1 tied 2"
    end

    it "links to Results" do
      createMatchForSeason nil
      @match = @season.matches.first

      visit season_matches_path :season_id => @season.id
      find("#match_#{@match.id}").click_link '1 vs 2'

      current_path.should == match_results_path(:match_id => @match.id)
    end
  end

  # helper function
  def createMatchForSeason(match)
    if match.nil?
      match = {
        :week_number => 1,
        :first_team => 1,
        :second_team => 2,
        :slot => 1
      }
    end

    # add a team to the season
    @season.matches.create(match)
  end
end
