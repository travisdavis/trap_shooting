module Logic
  module Big_Board
    class Big_Board_info
      def initialize(season)
        @season = season
      end # initialize

      def get_teams
        teams = []
        @season.teams.each do |team|
          team_info = Team_info.new(team)
          team_info.name = team.name
          teams.push(team_info)
        end
        #return
        teams
      end # get_teams
    end # Bigboards_info

    class Team_info
      attr_accessor :id, :number, :name

      def initialize(team)
        @team = team
        # only expose the properties we need
        self.id = @team.id
        self.number = @team.number
        self.name = @team.name
      end # initialize

      def get_shooters
        # just want the name, id and results of each shooter for now
        shooters = []
        @team.shooters.order(:position).each do |shooter|
          shooters.push(Shooter_info.new(shooter))
        end
        # return
        shooters
      end # get_shooters

      def get_weeks
        # initialize week_info
        weeks = []
        points_so_far = 0
        @team.get_schedule.each do |match|
          week = Week_info.new(@team)
          week.outcome = match.get_text_for_big_board @team.number

          match_points = match.get_points_for_match @team.number
          points_so_far += match_points unless (match_points.nil?)
          week.points_so_far = points_so_far unless (points_so_far == 0 || points_so_far.nil?)

          week.first_team = match.first_team
          week.second_team = match.second_team

          # lastly, calculate the team's total for the week
          week_team_scratch_plus_handicap = 0
          week.get_shooters.each do |shooter|
            shooter_info = shooter.get_shooter_results[match.week_number-1]
            if (!shooter_info.nil? && !shooter_info.total.nil?)
              week_team_scratch_plus_handicap+=shooter_info.total unless (shooter_info.total == 0)
              week.team_scratch_plus_handicap = week_team_scratch_plus_handicap
            end
          end

          weeks.push(week)
        end
        weeks
      end # get_weeks
    end # Team_info

    class Week_info
      attr_accessor :outcome, :points_so_far, :team_scratch_plus_handicap, :first_team, :second_team

      def initialize(team)
        @team = team
      end # initialize

      def get_shooters
        shooters = []
        @team.shooters.order(:position).each do |shooter|
          shooters.push(Shooter_info.new(shooter))
        end
        # return
        shooters
      end # get_shooters
    end # Week_info

    class Shooter_info
      attr_accessor :name, :id

      def initialize(shooter)
        @shooter = shooter
        self.name = @shooter.name
        self.id = @shooter.id
      end # initialize

      def get_shooter_results
        shooter_results = Array.new
        @shooter.results.each do |result|
          shooter_results[result.match.week_number-1] = Shooter_result.new(result)
        end
        shooter_results
      end # get_shooter_results
    end

    class Shooter_result
      attr_accessor :has_results,:id,:sixteen_yards,:handicap,:handicap_birds,:next_handicap_birds,:total,:is_blind_score

      def initialize(result)
        # TODO: remove code duplication between this and results.rb's version of the Shooter_info class
        self.has_results = false
        self.is_blind_score = false

        if !result.nil?
          self.id = result.id
          self.has_results = true
          self.is_blind_score = result.is_blind_score
          self.sixteen_yards = result.sixteen_yards

          self.handicap = result.handicap
          self.handicap_birds = result.get_previous_handicap_birds

          # don't get this from the db, calculate this on the fly
          self.next_handicap_birds = result.get_handicap_birds

          if result.is_blind_score
            # last week's average_scratch + handicap - 4
            average_scratch = result.get_average_for_previous_weeks
            if average_scratch == 0
              # no results yet, use 42
              total = 42
              self.handicap_birds = 0
              self.next_handicap_birds = 0
            else
              total = average_scratch+result.get_previous_handicap_birds-4
            end
          else
            if result.get_average_for_previous_weeks == 0
              # no results yet
              total = result.get_scratch_for_week+self.next_handicap_birds
              self.handicap_birds=self.next_handicap_birds
            else
              total = result.get_scratch_for_week+self.handicap_birds
            end
          end
          self.total = (total > 50 ? 50 : total)
        end
      end

      def scratch
        if is_blind_score
          nil
        else
          sixteen_yards = self.sixteen_yards.nil? ? 0 : self.sixteen_yards
          handicap = self.handicap.nil? ? 0 : self.handicap
          sixteen_yards+handicap
        end
      end
    end
  end
end
