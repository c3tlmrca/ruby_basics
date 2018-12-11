require './instance_counter.rb'

class Station
  include InstanceCounter
  attr_reader :trains, :name
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance
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

  def print_trains
    @trains.each.with_index(1) do |train, number|
      puts "#{number}. #{train.number} - #{train.type}."
    end
  end
end
