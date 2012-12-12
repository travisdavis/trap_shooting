class Season < ActiveRecord::Base
  include Logic::Schedule

  belongs_to :user, touch: true

  has_many :teams, :dependent => :destroy
  validates_associated :teams

  has_many :matches, :dependent => :destroy
  validates_associated :matches

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

  def get_schedule_for_team team_number
    self.matches.order(:week_number, :id).find(:all, :conditions => ["first_team = :team_number OR second_team = :team_number", { :team_number => team_number }])
  end

  ## end functions ##
end
