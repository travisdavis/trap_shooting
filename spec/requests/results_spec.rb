require 'spec_helper'

describe "Results" do
  before do
    @season = Season.create(
      :name => 'Fall of 2011',
      :start_date => Date.new(2011,10,12,6),
      :houses => 4,
      :time_slots => 2,
      :handicap_calculation => 0.7,
      :description => 'Santa Ynez Valley Sportsman Association Fall 2011 Trap Shooting League'
    )

    # add four teams
    for team_number in (1..4) do
      new_team = @season.teams.create({
        :number => team_number,
        :name => "Team #{team_number}",
        :description => "team #{team_number} description goes here"
      })

      # add five shooters
      for shooter_position in (1..5) do
        if team_number == 2 and shooter_position == 5
          new_team.shooters.create(
            :position => shooter_position,
            :name => "Shooter #{shooter_position}",
            :handicap_yardage => 27,
            :description => "Shooter #{shooter_position} description goes here",
            :casper => true
          )
        else
          new_team.shooters.create(
            :position => shooter_position,
            :name => "Shooter #{shooter_position}",
            :handicap_yardage => 27,
            :description => "Shooter #{shooter_position} description goes here"
          )
        end
      end
    end

    # add a matches
    @match1 = @season.matches.create({
      :week_number => 1,
      :first_team => 1,
      :second_team => 2,
      :slot => 1
    })
    @match2 = @season.matches.create({
      :week_number => 2,
      :first_team => 1,
      :second_team => 3,
      :slot => 1
    })
    #@match3 = @season.matches.create({
    #  :week_number => 3,
    #  :first_team => 2,
    #  :second_team => 3,
    #  :slot => 1
    #})
  end

  describe "GET /match_results" do
    it "should display a link to add results if they have not been added yet" do
      # there should be no shooters
      visit match_results_path :match_id => @match1.id

      page.should have_content "1 vs 2"
      page.should have_content "Add results"
    end

    it "should add results and calculate totals and the handicap" do
      # there should be no shooters
      visit match_results_path :match_id => @match1.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # fill in the form
      fill_in 'Sixteen yards', :with => 23
      fill_in 'Handicap', :with => 19
      click_button 'Create Result'

      current_path.should == match_results_path(:match_id => @match1.id)

      # should see five columns
      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("42")
      shooter_row.find(".next_handicap_birds").should have_content("6")
      shooter_row.find(".total_hit").should have_content("48")
      page.should have_content "Result Created"

      # add a second result for shooter1
      visit match_results_path :match_id => @match2.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # fill in the form
      fill_in 'Sixteen yards', :with => 22
      fill_in 'Handicap', :with => 23
      click_button 'Create Result'

      current_path.should == match_results_path(:match_id => @match2.id)

      # should see five columns
      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("45")
      shooter_row.find(".next_handicap_birds").should have_content("4")
      shooter_row.find(".total_hit").should have_content("50")
      page.should have_content "Result Created"
    end

    it "should handle blind scores" do
      # there should be no shooters
      visit match_results_path :match_id => @match1.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # fill in the form
      fill_in 'Sixteen yards', :with => 23
      fill_in 'Handicap', :with => 19
      click_button 'Create Result'

      current_path.should == match_results_path(:match_id => @match1.id)

      # should see five columns
      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("42")
      shooter_row.find(".next_handicap_birds").should have_content("6")
      shooter_row.find(".total_hit").should have_content("48")
      page.should have_content "Result Created"

      # add a second result for shooter1
      visit match_results_path :match_id => @match2.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # check the check box
      check 'Is blind score'
      click_button 'Create Result'

      current_path.should == match_results_path(:match_id => @match2.id)

      # should see five columns
      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("")
      shooter_row.find(".next_handicap_birds").should have_content("6")
      shooter_row.find(".total_hit").should have_content("44")
      page.should have_content "Result Created"
    end

    it "should handle first week blind score" do
      # there should be no shooters
      visit match_results_path :match_id => @match1.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # check is blind score
      check 'Is blind score'
      click_button 'Create Result'

      current_path.should == match_results_path(:match_id => @match1.id)

      # should see five columns
      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("0")
      shooter_row.find(".next_handicap_birds").should have_content("0")
      shooter_row.find(".total_hit").should have_content("42")
      page.should have_content "Result Created"

      # now add results for week 2
      # add a second result for shooter1
      visit match_results_path :match_id => @match2.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # fill in the form
      fill_in 'Sixteen yards', :with => 23
      fill_in 'Handicap', :with => 20
      click_button 'Create Result'

      current_path.should == match_results_path(:match_id => @match2.id)

      # should see five columns
      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("43")
      shooter_row.find(".handicap_birds").should have_content("5")
      shooter_row.find(".next_handicap_birds").should have_content("5")
      shooter_row.find(".total_hit").should have_content("48")
      page.should have_content "Result Created"
    end
  end

  describe "PUT /season" do
    it "requires sixteen_yards and handicap values" do
      visit match_results_path :match_id => @match1.id
      shooter_id = @season.teams.first.shooters.first.id

      find("#shooter_#{shooter_id}").click_link "Add results"

      # fill in the form
      fill_in 'Sixteen yards', :with => 20
      # leav handicap blank
      #fill_in 'Handicap', :with => 20
      click_button 'Create Result'

      # should be an error message
      page.should have_content 'There was a problem creating the result.'
    end

    it "edits a season" do
      # there should be no shooters
      visit match_results_path :match_id => @match1.id

      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Add results"

      # fill in the form
      fill_in 'Sixteen yards', :with => 20
      fill_in 'Handicap', :with => 20
      click_button 'Create Result'

      # Edit the results
      find("#shooter_#{@season.teams.first.shooters.first.id}").click_link "Edit"

      current_path.should == edit_result_path(Result.where(:match_id => @match1.id, :shooter_id => @season.teams.first.shooters.first.id).first.id)

      fill_in 'Sixteen yards', :with => 15
      fill_in 'Handicap', :with => 15
      click_button 'Update Result'

      shooter_row = find("#shooter_#{@season.teams.first.shooters.first.id}")
      shooter_row.find(".scratch").should have_content("30")
      shooter_row.find(".next_handicap_birds").should have_content("14")
      shooter_row.find(".total_hit").should have_content("44")
      #page.should have_content "Result Updated"
    end
  end

  describe "DELETE /result" do
    it "should delete a result" do

    end
  end
end
