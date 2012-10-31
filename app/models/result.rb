class Result < ActiveRecord::Base
  belongs_to :match
  has_one :shooter
  has_one :season, :through => :match

  attr_accessible :sixteen_yards, :handicap, :match_id, :shooter_id, :is_blind_score

  ## validations ##
  validates :sixteen_yards, presence: true, :if => :should_validate_sixteen_and_handicap?
  validates :handicap, presence: true, :if => :should_validate_sixteen_and_handicap?
  ## end validations ##

  def should_validate_sixteen_and_handicap?
    is_blind_score == false
  end

  def get_average_for_previous_weeks
    if self.match_id != nil
      current_match = Match.find(self.match_id)
      shooter = Shooter.find(self.shooter_id)

      if shooter != nil
        week_number_to_use = ((current_match.week_number-1) < 1 ? 1 : current_match.week_number-1)
        scratch = shooter.calculate_average_upto_week_number week_number_to_use
      end
    end
    return scratch.nil? ? 0 : Integer(scratch)
  end

  def get_scratch_for_week
    scratch = 0
    if !self.is_blind_score
      scratch = self.sixteen_yards + self.handicap
    end
    return scratch
  end

  def get_previous_handicap_birds
    if self.match_id != nil
      current_match = Match.find(self.match_id)
      shooter = Shooter.find(self.shooter_id)

      if shooter != nil
        week_number_to_use = ((current_match.week_number-1) < 1 ? 1 : current_match.week_number-1)
        handicap_birds = shooter.calculate_handicap_for_week_number(week_number_to_use)
      end
    end
    return handicap_birds.nil? ? 0 : Integer(handicap_birds)
  end

  def get_handicap_birds
    if self.match_id != nil
      current_match = Match.find(self.match_id)
      shooter = Shooter.find(self.shooter_id)

      if shooter != nil
        week_number_to_use = current_match.week_number < 1 ? 1 : current_match.week_number
        handicap_birds = shooter.calculate_handicap_for_week_number(week_number_to_use)
      end
    end
    return handicap_birds.nil? ? 0 : Integer(handicap_birds)
  end

  def get_scratch_plus_handicap
    if !self.match_id.nil?
      raw = self.get_scratch_for_week + self.get_previous_handicap_birds
      if raw >= 50
        return 50
      else
        return raw
      end
    end
  end
end
