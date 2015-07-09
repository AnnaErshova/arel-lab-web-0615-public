class Classification < ActiveRecord::Base
  has_many :boat_classifications
  has_many :boats, through: :boat_classifications
  require 'pry'

  # Classification::my_all returns all classifications
  # classifications = ["Ketch", "Sailboat", "Catamaran", "Sloop", "Motorboat", "Center Console", "RIB", "Trawler", "Cat Rig Boat", "Bass Boat", "Pontoon Boat"]
  def self.my_all
    #binding.pry
    select(:name)
    # self.pluck(:name) -- this should freaking work
  end

  # Classification#longest returns the classifications for the longest boat
  # find longest boat, then find classification
  def self.longest
    #binding.pry
    joins(:boats).select(:classification).where(:boats => {:length => Boat.maximum(:length)})
  end
end
