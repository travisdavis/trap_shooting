class Shooter < ActiveRecord::Base
  belongs_to :team
  has_many :results, :dependent => :destroy
  has_many :matches, :through => :results
  has_one :season, :through => :team

  attr_accessible :team_id, :position, :name, :handicap_yardage, :description, :casper

  ## validations ##
  validates :position,
    presence: true,
    :uniqueness => {
      :scope => :team_id,
      :message => "shooter positions are unique per team" },
    :inclusion => { :in => 1..5 }
  validates :name, presence: true, :unless => :casper
  validates :handicap_yardage, :inclusion => { :in => 16..27 }, :unless => :casper
  ## end validations ##

  ## callbacks ##
  before_save :handle_casper
  ## end callbacks ##

  def calculate_handicap_for_week_number week_number
    # pre condition, must have results for each week upto and including the passed in week_number
    
    # sum total scratch upto this week
    average = calculate_average_upto_week_number week_number

    # handicap is (50 - average)*XX%
    ((50 - average)*(self.season.handicap_calculation)).round
  end

  def calculate_average_upto_week_number week_number
    results = self.results

    results_sum = 0.0
    number_of_weeks_to_exclude_from_average = 0

    results.each do |result|
      match = Match.find result.match_id
      if match.week_number <= week_number
        if result.is_blind_score
          number_of_weeks_to_exclude_from_average+=1
        else
          results_sum += result.get_scratch_for_week
        end
      end
    end

    # then create the average
    if (week_number-number_of_weeks_to_exclude_from_average > 0)
      average = (results_sum/(week_number-number_of_weeks_to_exclude_from_average)).round
    else
      average = results_sum
    end
    return average
  end

  private
  
    # casper shooters do not have a settable name
    def handle_casper
      if self.casper
        self.name = "Casper"
        self.handicap_yardage = nil
      end
    end
end