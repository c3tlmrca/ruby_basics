require './manufactured_by.rb'

class Car
  include ManufacturedBy
  attr_reader :added

  def inititalize(manufacturer = nil)
    self.manufacturer = manufacturer
    @added = false
  end

  def add_car!
    @added = true unless added?
  end

  def remove_car!
    @added = false if added?
  end

  def added?
    @added
  end
end
