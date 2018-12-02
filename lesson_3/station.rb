class Station
  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    return if @trains.include?(train)

    @trains << train if train.is_a?(Train)
  end

  def remove_train(train)
    trains.delete(train)
  end

  def count_trains_by_type(type)
    trains.count { |train| train.type == type }
  end
end
