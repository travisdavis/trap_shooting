require 'spec_helper'
require 'date'

describe "Bigboards" do
  before do
    @season1 = Season.create(
      :name => 'Fall of 2011',
      :start_date => Date.new(2011,10,12,6),
      :houses => 4,
      :time_slots => 2,
      :handicap_calculation => 0.7,
      :description => 'Santa Ynez Valley Sportsman Association Fall 2011 Trap Shooting League'
    )
    @season2 = Season.create(
      :name => 'Spring of 2012',
      :start_date => Date.new(2012,2,22,6),
      :houses => 4,
      :time_slots => 2,
      :handicap_calculation => 0.7,
      :description => 'Santa Ynez Valley Sportsman Association Spring 2012 Trap Shooting League'
    )

    # add four teams
    for team_number in (1..4) do
      new_team = @season1.teams.create({
        :number => team_number,
        :name => "Team #{team_number}",
        :description => "team #{team_number} description goes here"
      })

      # add five shooters per team
      for shooter_position in (1..5) do
        new_team.shooters.create(
          :position => shooter_position,
          :name => "Shooter #{shooter_position}",
          :handicap_yardage => 27,
          :description => "Shooter #{shooter_position} description goes here"
        )
      end
    end

    # generate and save the schedule
    schedule = @season1.create_schedule @season1.teams.count, false

    for round in 0..(schedule.count)
      if schedule[round].nil?
        next
      end

      for match in 0..(schedule[round].count-1)
        teams = schedule[round][match].split(":")
        @season1.matches.create(
          :week_number => round+1,
          :slot => match,
          :first_team => Integer(teams[0]),
          :second_team => Integer(teams[1])
        )
      end
    end
  end

  # this is a display only page
  describe "GET /bigboards" do
    it "display 'need to add seasons' message when no seasons exist" do
      # remove existing seasons
      Season.delete(@season1)
      Season.delete(@season2)

      visit bigboards_path

      # should see a list of bigboards
      page.should have_content 'Add a season using the season page'

      # TODO: verify the link goes to seasons_path
    end

    it "displays a list of seasons when they exist" do
      visit bigboards_path

      page.should have_content 'Fall of 2011'
      page.should have_content 'Spring of 2012'
    end
  end

  describe "GET /bigboards/id" do
  	it "displays the bigboard for a season" do
      visit bigboards_path

      # find the first season and click view bigboard link
      find("#season_#{@season1.id}").click_link 'View Big Board'

      current_path.should == bigboard_path(@season1.id)

      matches = @season1.matches.order(:id)

      first_match = matches.first

      # for each team in the match
      first_match_first_team = @season1.teams.find_by_number(first_match.first_team)
      first_match_second_team = @season1.teams.find_by_number(first_match.second_team)

      # add resluts for each shooter
      for shooter in first_match_first_team.shooters
        result = first_match.results.create(
          :match_id => first_match.id,
          :shooter_id => shooter.id,
          :sixteen_yards => 20,
          :handicap => 21
        )
      end

      # should have the season's title
      page.should have_content 'Fall of 2011'

      # should see the teams in order
      for team in @season1.teams.order(:number)
        team_dom = find("#team_#{team.id}")
        team_dom.should have_content "Team "+team.number.to_s

        # Should display team's schedule "x vs y"
        for match in @season1.get_schedule_for_team team.number
          team_dom.should have_content "#{match.first_team} vs #{match.second_team}"
        end

        # teams should display its shooters and their results
        for shooter in team.shooters
          # name first
          shooter_dom = find("#shooter_#{shooter.id}")
          shooter_dom.should have_content "Shooter "+shooter.position.to_s

          for match in @season1.get_schedule_for_team team.number
            result = Result.find_by_shooter_id shooter.id
            # handicap

            # scratch
            # handicap + scratch
          end
        end

        # Should display match result with points, W|L|T and team total for scratch + handicap

      end
  	end
  end
end
