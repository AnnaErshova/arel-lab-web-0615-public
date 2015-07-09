class Boat < ActiveRecord::Base

  require 'pry'
  belongs_to  :captain
  has_many    :boat_classifications
  has_many    :classifications, through: :boat_classifications

  # Boat.first_five.pluck(:name) -- already selects by name
=begin
  [#<Boat:0x007fc6a3adca70
  id: 1,
  name: "H 28",
  length: 27,
  captain_id: 1,
  created_at: Thu, 09 Jul 2015 15:48:42 UTC +00:00,
  updated_at: Thu, 09 Jul 2015 15:48:42 UTC +00:00>]
=end

  # Boat::first_five returns the first five Boats
  # boats = ["H 28", "Nacra 17", "Regulator 34SS", "Zodiac CZ7", "Boston Whaler"]
  def self.first_five
    limit(5)
  end

    # self.project(Arel.sql[:name])
  #  Boat.all.select(:name)
    # self.arel_table[:name]
  
  # returns boats 20 feet or shorter
  def self.dinghy
    # where.length(>=20)
    where(arel_table[:length].lteq(20))
  end

  # returns boats 20 feet or longer -- but this assumes that a boat that is 20 feet is both a ship and a dinghy
  def self.ship
    where(arel_table[:length].gteq(20))
  end

  # returns last three boats in alphabetical order
  # organize alphabetically first, then take last 3
  def self.last_three_alphabetically
    order(:name => :desc).limit(3)
    # binding.pry
    # details = User.select(:id, :email, :first_name).order(id: :desc)
    # ["Zodiac CZ7", "Triton 21 TRX", "Sunfish"]
  end

  # without_a_captain
  def self.without_a_captain
    # Boat.all.where("captain_id" => nil)
    where(arel_table["captain_id"].eq(nil))
  end

  # returns all boats that are sailboats
  def self.sailboats
    # joins(:classifications).where(:classifications => {:name => "Sailboat" })
    joins(:classifications).merge(Classification.where(:name => "Sailboat"))
  end

  # returns boats with three classifications
  def self.with_three_classifications
    joins(:boat_classifications).group(:boat_id).having(arel_table[:id].count.eq(3))
    # photos.group(photos[:user_id]).having(photos[:id].count.gt(5)) 
    # => SELECT FROM photos GROUP BY photos.user_id HAVING COUNT(photos.id) > 5
  end

end # end class


#users.project(users[:id])
# => SELECT users.id FROM users

#users = Arel::Table.new(:users)
#query = users.project(Arel.sql('*'))
#query.to_sql