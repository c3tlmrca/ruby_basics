require './instance_counter.rb'
require './validator.rb'

class Route
  include Validator
  include InstanceCounter
  attr_reader :stations

  THIS_IS_NOT_STATION = 'Это не станция.'.freeze
  FIRST_EQUAL_LAST = 'Первая и последняя станции не должны быть одинаковыми.'.freeze

  def initialize(stations)
    @stations = stations
    validate!
    register_instance
  end

  def add_station(station)
    return unless station.is_a?(Station)

    @stations.insert(-2, station)
  end

  def remove_station(station)
    return if [@stations.first, @stations.last].include?(station)

    @stations.delete(station)
  end

  private

  def validate!
    raise THIS_IS_NOT_STATION unless @stations.all?{ |station| station.is_a?(Station)}
    raise FIRST_EQUAL_LAST if @stations.first.eql?(@stations.last)
  end
end
