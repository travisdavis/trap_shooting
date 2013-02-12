class Season < ActiveRecord::Base
  include Logic::Schedule

  default_scope order('start_date ASC')

  belongs_to :user, touch: true

  has_many :teams, :dependent => :destroy, :order => 'number ASC'
  validates_associated :teams

  has_many :matches, :dependent => :destroy
  validates_associated :matches

  has_many :missed_weeks, :dependent => :destroy, :order => 'week_number ASC'
  validates_associated :missed_weeks

  attr_accessible :name, :user_id, :start_date, :houses, :time_slots, :handicap_calculation, :description

  ## validations ##
  validates :name, presence: true
  #:start_date TODO update validation
  validates :houses, presence: true
  validates :time_slots, presence: true
  validates_numericality_of :handicap_calculation, :greater_than => 0, :less_than => 1
  # :description is optional
  ## end validations ##

  ## functions ##
  def get_matches_by_week(week_number)
    self.matches.where(:week_number => week_number)
  end

  def add_teams_and_shooters(number_of_teams)
    # create params[:number_of_teams_to_create]
    puts "create #{number_of_teams} teams"
    (1..number_of_teams).each do |team_number|
      new_team = self.teams.create(
        :number => team_number,
        :name => "Team #{team_number}",
        :description => "Team #{team_number} description goes here"
      )

      # add five shooters
      puts "add five shooters for team #{team_number}"
      (1..5).each do |shooter_position|
        new_team.shooters.create(
          :position => shooter_position,
          :name => "Shooter #{shooter_position}",
          :handicap_yardage => 27,
          :description => "Shooter #{shooter_position} description goes here"
        )
      end
    end
  end

  def is_missed_week week_number
    if @missed_weeks.nil?
      @missed_weeks = []
      self.missed_weeks.each do |missed_week|
        @missed_weeks.push missed_week.week_number
      end
    end

    return @missed_weeks.include?(week_number)
  end

  def get_missed_weeks
    missed_weeks_raw = []
    self.missed_weeks.each do |missed_week|
      if !missed_week.week_number.nil?
        missed_weeks_raw.push self.get_week(missed_week.week_number)
      end
    end

    missed_weeks = []
    (0..missed_weeks_raw.length-1).each do |index|
      a_missed_week = missed_weeks_raw[index]
      week_date_org = a_missed_week.date_raw

      if !a_missed_week.week_number.nil?
        week_date = Date.parse(week_date_org.to_s)+(7*(self.teams.count-a_missed_week.week_number+index))
        week_matches = self.matches.scoped_by_week_number a_missed_week.week_number

        missed_weeks.push Week_info.new a_missed_week.week_number, week_date, self.time_slots, week_matches, self.houses, false
      end
    end
    return missed_weeks
  end
  ## end functions ##
end
