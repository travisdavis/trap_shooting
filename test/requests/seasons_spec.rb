require 'spec_helper'
require 'date'

describe "Seasons" do
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

  describe "GET /seasons" do
    # add a test for case where no seasons exist

    it "display some seasons" do
      visit seasons_path
      page.should have_content 'Fall of 2011'
    end

    it "creates a new season" do
      visit seasons_path
      fill_in 'Name', :with => 'Another Season'
      # start date...
      fill_in 'Houses', :with => 4
      fill_in 'Time slots', :with => 2
      fill_in 'Handicap calculation', :with => 0.7
      # description is not required
      
      click_button 'Create Season'

      current_path.should == seasons_path

      # notice value
      page.should have_content 'Season Created'
      
      # new seasons name
      page.should have_content 'Another Season'
    end

    it "links to Teams" do
      visit seasons_path
      find("#season_#{@season.id}").click_link "#{@season.teams.count}"

      current_path.should == season_teams_path(:season_id => @season.id)
    end
    
    it "should display the number of teams the season currently" do
      visit seasons_path

      # no teams added to the season yet so we should see a zero
      page.should have_content 'has 0 team(s)'
      
      # add a team and then is should have one team
      @season.teams.create(
        :number => 1,
        :name => 'Team 1',
        :description => 'This team has some of the best shooters in the league'
      )
      visit seasons_path # update the display
      page.should have_content 'has 1 team(s)'
      
    end

    it "links to Matches" do
      visit seasons_path
      page.has_content?('View Schedule')
      find("#season_#{@season.id}").click_link 'View Schedule'

      current_path.should == season_matches_path(:season_id => @season.id)
    end

    it "links to the Bigboards" do
      visit seasons_path
      page.has_content?('View Big Board')
      find("#season_#{@season.id}").click_link 'View Big Board'

      current_path.should == bigboard_path(@season.id)
    end
  end
  
  describe "PUT /season" do
    it "edits a season" do
      visit seasons_path
      click_link 'Edit'

      current_path.should == edit_season_path(@season)

      find_field('Name').value.should == 'Fall of 2011'

      fill_in 'Name', :with => 'updated season name'
      click_button 'Update Season'

      current_path.should == seasons_path

      # notice should be on the page
      page.should have_content 'Season successfully updated.'

      # updated season name should be on the page
      page.should have_content 'updated season name'
    end
        
    it "should not update an invalid season" do
      visit seasons_path
      find("#season_#{@season.id}").click_link 'Edit'

      fill_in 'Name', :with => ''
      click_button 'Update Season'

      current_path.should == edit_season_path(@season)
      page.should have_content 'There was a problem updating the season.'
    end
  end
  
  describe "DELETE /season" do
    it "should delete a season" do
       visit seasons_path
       find("#season_#{@season.id}").click_link 'Delete'

       current_path.should == seasons_path

       page.should have_content 'Season has been deleted'
       page.should have_no_content 'Fall of 2011'
     end
   end
end
