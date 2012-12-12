class Team < ActiveRecord::Base
  belongs_to :season, touch: true
  has_many :shooters, :dependent => :destroy
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
  ## end functions ##
end
