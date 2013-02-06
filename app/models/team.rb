class Team < ActiveRecord::Base
  include Logic::Results

  belongs_to :season, touch: true
  has_many :shooters, :dependent => :destroy, :order => 'position ASC'
  validates_associated :shooters

  attr_accessible :season_id, :number, :name, :description, :clean_up_week_number

  ## validations ##
  validates :season_id, presence: true

  # team number is unique per season
  validates :number, presence: true, :uniqueness => { :scope => :season_id,
      :message => "team numbers are unique per season" }
  validates :name, presence: true
  # :clean_up_week_number and :description are optional
  ## end validations ##

  ## functions ##
  def get_team_scratch_plus_handicap current_match
    scratch_plus_handicap = 0

    first_team_info = Team_info.new(self, current_match.id)

    return first_team_info.total
  end

  def get_schedule
    return self.season.matches.order(:week_number, :id).find(:all, :conditions => ["first_team = :team_number OR second_team = :team_number", { :team_number => self.number }])
  end

  def get_total_points_through_week week_number
    total_points = 0
    self.get_schedule.each do |match|
      if match.week_number <= week_number
        total_points+=match.get_points_for_match self.number
      end
    end
    return total_points
  end
  ## end functions ##
end
