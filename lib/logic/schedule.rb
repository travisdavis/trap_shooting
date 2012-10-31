module Logic
  module Schedule
    def create_Type1_schedule
      # this is the schedule that SYVSA currently uses
      schedule = [
        ["12:15","6:10","11:3","1:4","9:14","2:5","13:7","8:16"],
        ["8:5","11:14","7:9","3:13","15:4","1:6","10:12","16:2"],
        ["10:11","3:5","12:4","14:2","6:8","1:9","15:13","16:7"],
        ["7:4","2:13","5:11","12:3","1:10","15:8","6:14","9:16"],
        ["12:7","6:3","10:8","5:9","1:15","14:4","2:11","16:13"],
        ["6:2","13:8","3:10","7:1","9:11","15:14","5:4","16:12"],
        ["4:3","15:10","14:12","7:6","5:13","2:9","1:8","11:16"],
        ["6:12","8:4","9:15","10:13","2:7","1:11","14:5","3:16"],
        ["7:14","8:3","2:10","4:11","15:5","12:13","9:6","16:1"],
        ["9:10","2:3","11:15","8:12","13:1","4:6","7:5","16:14"],
        ["15:3","14:1","4:2","12:5","10:7","8:9","13:11","6:16"],
        ["2:8","11:7","9:3","14:13","6:15","4:10","12:1","5:16"],
        ["11:12","5:1","8:14","15:2","6:13","3:7","4:9","10:16"],
        ["10:5","3:14","11:6","7:8","13:4","12:9","1:2","16:15"],
        ["13:9","2:12","3:1","11:8","10:14","5:6","7:15","4:16"],
      ]
      schedule
    end

    def create_schedule number_of_teams, balance #, random_starting_team
      nr = number_of_teams - 1
      n = number_of_teams

      schedule = []

      for r in 1..n-1
        round = []
        for i in 1..n/2
          if (i==1)
            round.push "1:#{(n-1+r-1)%(n-1)+2}"
          else
            round.push "#{(r+i-2)%(n-1)+2}:#{(n-1+r-i)%(n-1)+2}"
          end
        end
        schedule.unshift(round)
      end

      if balance
        schedule = balance schedule
      end

      # return
      schedule
    end

    def balance schedule
      # Now court balance may be obtained by making the following adjustments:
      # for r=1...(n/2)-1, swap over pairs from courts 1 and r+1.
      # for r=n/2...n-2, swap over pairs from courts 1 and n-r.
      # for r=n-1, leave the round unchanged.
      number_of_teams = schedule.count+1
      for r in 0..(schedule.count-1)
        schedule[r] = balance_round schedule[r], r, number_of_teams
      end

      schedule
    end

    def balance_round round, round_number, number_of_teams
      r = round_number
      n = number_of_teams
      if r <= (n/2)
        round[0], round[r-1] = round[r-1], round[0]
      elsif r == (n-1)
        # no op
      else
        round[0], round[n-1-r] = round[n-1-r], round[0]
      end

      round
    end

    def create_balanced_schedule number_of_teams
      create_schedule number_of_teams, true
    end

    def get_schedule
      schedule = []
      for week_number in (1..(self.teams.count-1))
        week_date = Date.parse(self.start_date.to_s)+(7*(week_number-1))
        week_matches = self.matches.scoped_by_week_number week_number

        week = {}
        week["week_number"] = week_number
        week["date_raw"] = week_date
        week["date"] = "#{week_date.month}-#{week_date.day}-#{week_date.year}"
        week["times"] = ["6:00 pm"]

        if self.time_slots > 1
          # add another hour to 'times' if
          week["times"].push "7:00 pm"
        end
        week["matches"] = []

        for index in (0..week_matches.count-1)
          match = week_matches[index]
          if !match.nil?
            schedule_match = {}
            schedule_match["id"] = match.id
            schedule_match["display_text"] = match.get_text_for_schedule

            if !week["matches"][index%self.houses].kind_of?(Array)
              week["matches"][index%self.houses] = []
            end
            week["matches"][index%self.houses].push schedule_match
          end
        end

        schedule.push week
      end

      schedule
    end
  end
end
