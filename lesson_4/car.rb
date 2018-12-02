class Car
  attr_reader :added

  def inititalize
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
