class Match < ActiveRecord::Base
  belongs_to :season, touch: true
  has_many :results, :dependent => :destroy

  attr_accessible :season_id, :week_number, :first_team, :second_team, :slot, :outcome

  ## validations ##
  validates :outcome, :inclusion => { :in => -1..2 }
  ## end validations ##

  ## functions ##
  def get_text_for_schedule
    match_text = ""
    case self.outcome
      when OUTCOME_TIE
        match_text = "tied"
      when OUTCOME_FIRST_TEAM_WIN
        match_text = "beat"
      when OUTCOME_SECOND_TEAM_WIN
        match_text = "loss"
      else
        match_text = "vs"
    end
    "#{self.first_team} #{match_text} #{self.second_team}"
  end

  def get_text_for_big_board team_number
    case self.outcome
      when OUTCOME_TIE
        match_text = "T"
      when OUTCOME_FIRST_TEAM_WIN
        match_text = "L"
        if team_number == self.first_team
          match_text = "W"
        end
      when OUTCOME_SECOND_TEAM_WIN
        match_text = "L"
        if team_number == self.second_team
          match_text = "W"
        end
      else
        match_text = ""
    end
    match_text
  end

  def get_points_for_match team_number
    case self.outcome
      when OUTCOME_TIE
        match_points = 1
      when OUTCOME_FIRST_TEAM_WIN
        if team_number == self.first_team
          match_points = 2
        end
      when OUTCOME_SECOND_TEAM_WIN
        if team_number == self.second_team
          match_points = 2
        end
    end
    match_points
  end
  ## end functions ##

  ## ENUMS?!? ##
  OUTCOME_NONE=-1
  OUTCOME_TIE=0
  OUTCOME_FIRST_TEAM_WIN=1
  OUTCOME_SECOND_TEAM_WIN=2
  ## end ENUMS ##
end
