require 'spec_helper'

describe "Shooters" do
  before do
    @season = Season.create(
      :name => 'Fall of 2011',
      :start_date => Date.new(2011,10,12,6),
      :houses => 4,
      :time_slots => 2,
      :handicap_calculation => 0.7,
      :description => 'Santa Ynez Valley Sportsman Association Fall 2011 Trap Shooting League'
    )
    @season.teams.create(
      :number => 1,
      :name => 'Team 1',
      :description => 'This team has some of the best shooters in the league'
    )

    @team = @season.teams.first
  end

  describe "GET /team_shooters" do
    it "should ask user to create a shooter if none exist" do
      # there should be no shooters
      visit team_shooters_path :team_id => @team.id
      page.should have_content "To add a shooter using the form below."
    end

    it "creates a new shooter" do
      visit team_shooters_path :team_id => @team.id

      # fill in the form :position, :name, :handicap_yardage, :description
      fill_in 'Position', :with => 1
      fill_in 'Name', :with => 'Shooter 1'
      fill_in 'Handicap yardage', :with => 27
      fill_in 'Description', :with => 'shooter description goes here'

      click_button 'Create Shooter'

      current_path.should == team_shooters_path(:team_id => @team.id)

      # notice value
      page.should have_content 'Shooter Created'
      
      # new seasons name
      page.should have_content 'Shooter 1'
    end

    it "creates a new casper shooter" do
      visit team_shooters_path :team_id => @team.id

      check 'Casper'
      fill_in 'Position', :with => 1

      click_button 'Create Shooter'

      page.should have_content 'Casper'
      page.should have_content 'n/a'
    end

    it "will not create two teams with the same position" do
      createShooterForTeam nil
      @shooter = @team.shooters.first

      visit team_shooters_path :team_id => @team.id

      # fill in the form
      fill_in 'Position', :with => 1
      fill_in 'Name', :with => 'another shooter name'
      fill_in 'Handicap yardage', :with => 27
      fill_in 'Description', :with => 'another shooter description'

      click_button 'Create Shooter'

      current_path.should == team_shooters_path(:team_id => @team.id)

      # notice should be on the page
      page.should have_content 'There was a problem creating the shooter.'
    end

    it "display some teams" do
      createShooterForTeam nil

      visit team_shooters_path(:team_id => @team.id)

      page.should have_content 'Shooter 1'

      # the form to create a shooter should be on the page
      page.should have_button 'Create Shooter'
    end

    it "should not display the create form if five already exist" do
      for i in 1..5
        shooter = {
          :position => i,
          :name => "Shooter #{i}",
          :handicap_yardage => 27,
          :description => "shooter #{i} description goes here"
        }
        createShooterForTeam shooter
      end

      visit team_shooters_path(@team)

      # there has to be a better way to do this
      page.should_not have_button('Create Shooter')
    end

    it "links to Results" do
      
    end
  end

  describe "PUT /shooter" do
    it "edits shooters" do
      createShooterForTeam nil
      @shooter = @team.shooters.first

      visit team_shooters_path(:team_id => @team.id)

      click_link 'Edit'
      current_path.should == edit_shooter_path(@shooter)

      fill_in 'Position', :with => 2
      fill_in 'Name', :with => 'updated shooter name'
      fill_in 'Handicap yardage', :with => 26
      fill_in 'Description', :with => 'updated description'
      click_button 'Update Shooter'

      current_path.should == team_shooters_path(:team_id => @team.id)

      # verify notice
      page.should have_content 'Shooter successfully updated.'

      # verify updated shooter name
      page.should have_content 'updated shooter name'
    end

    it "should not update an invalid team" do
      createShooterForTeam nil
      @shooter = @team.shooters.first

      visit team_shooters_path(:team_id => @team.id)
      click_link 'Edit'

      fill_in 'Name', :with => ''

      click_button 'Update Shooter'

      current_path.should == edit_shooter_path(@shooter)
      # verify notice
      page.should have_content 'There was a problem updating the Shooter.'
    end

    it "shooter position should be unique per team" do
      createShooterForTeam nil
      second_season = {
        :position => 2,
        :name => 'Shooter 2',
        :handicap_yardage => 27,
        :description => 'shooter 2 description goes here'
      }
      createShooterForTeam second_season

      visit team_shooters_path :team_id => @team.id
      find("#shooter_#{@team.shooters.second.id}").click_link 'Edit'

      fill_in 'Position', :with => "1"
      click_button 'Update Shooter'
      page.should have_content 'There was a problem updating the Shooter.'
    end
  end

  describe "DELETE /shooter" do
    it "should delete a shooter" do 
      createShooterForTeam nil

      visit team_shooters_path :team_id => @team.id
      click_link 'Delete'

      current_path.should == team_shooters_path(:team_id => @team.id)
      page.should have_content 'Shooter has been deleted.'
    end
  end
  
  # helper function
  def createShooterForTeam(shooter)
    if shooter.nil?
      shooter = {
        :position => 1,
        :name => 'Shooter 1',
        :handicap_yardage => 27,
        :description => 'shooter description goes here'
      }
    end

    # add a team to the season
    @team.shooters.create(shooter)
  end
end