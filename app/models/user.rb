class User < ActiveRecord::Base
  has_many :services, :dependent => :destroy
  validates_associated :services

  has_many :seasons, :dependent => :destroy
  validates_associated :seasons

  attr_accessible :name, :email
end
