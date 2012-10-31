module Logic
  module Results
    class Team_info
      def initialize(team, match_id)
        @total = 0
        @shooters_results = []

        team.shooters.each do |shooter|
          result = shooter.results.where(:match_id => match_id).first
          shooter_result = Shooter_info.new(shooter, result)

          if !result.nil?
            @total += shooter_result.total
          end

          @shooters_results[shooter.position-1] = shooter_result
        end
      end

      def get_shooters_results
        @shooters_results
      end

      def has_all_results_reported
        # this might not be right for caspers
        retval = true
        @shooters_results.each do |result|
          # if one of the shooters does not have a result, return false
          if result.has_results == false
            retval = false
          end
        end
        return retval
      end

      def total
        @total
      end
    end

    class Shooter_info
      attr_accessor :has_results,:id,:name,:sixteen_yards,:handicap,:handicap_birds,:next_handicap_birds,:total,:is_blind_score

      def initialize(shooter, result)
        #
        self.has_results = false
        self.id = shooter.id
        self.name = shooter.name
        self.is_blind_score = false

        if !result.nil?
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
          0
        else
          self.sixteen_yards+self.handicap
        end
      end
    end
  end
end
