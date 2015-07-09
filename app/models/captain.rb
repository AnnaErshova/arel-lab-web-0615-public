class Captain < ActiveRecord::Base
  require 'pry'
  has_many :boats

  #Captain.method.pluck(:name)

  # id: 1,
  # name: "Captain Cook",
  # admiral: true,
  # created_at: Thu, 09 Jul 2015 16:24:09 UTC +00:00,
  # updated_at: Thu, 09 Jul 2015 16:24:09 UTC +00:00>,

  # returns all captains of catamarans
  def self.catamaran_operators
    joins(:boats => :classifications)
      .where(
        :classifications => {
          :name => "Catamaran"
          })
  end

  # returns captains with sailboats
  def self.sailors
    joins(:boats => :classifications)
      .where(
        :classifications => {
          :name => "Sailboat"
          })
          .group("boats.id")
            .uniq
  end
  #       expected: ["Captain Cook", "Captain Kidd", "Samuel Axe"]
  #          got: ["Captain Cook", "Captain Kidd", "Samuel Axe", "Captain Cook"] == uniq? -- group(:id) did not work
       
  # returns captains of motorboats and sailboats
  def self.talented_seamen
    joins(:boats => :classifications)
      .where("classifications.name == 'Sailboat' or classifications.name == 'Motorboat'") # there has to be a way to do this with a hash
        .group("classifications.id")
  end

  # returns people who are not captains of sailboats
  # expected: ["William Kyd", "Arel English", "Henry Hudson"]
  #          got: ["Captain Cook", "Captain Kidd", "William Kyd", "Arel English", "Henry Hudson", "Samuel Axe"]
  def self.non_sailors
    where.not(:name => self.sailors.pluck(:name))
  end

end # end class
