require './instance_counter.rb'
require './validation.rb'
require './accessors.rb'

class Route
  include Validator
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :stations

  validate station.first.to_sym, :type, Station
  validate station.last.to_sym, :type, Station

  def initialize(stations)
    @stations = stations
    validate!
    register_instance
  end

  def first_station
    @stations.first
  end

  def last_station
    @stations.last
  end

  def add_station(station)
    return unless station.is_a?(Station)

    @stations.insert(-2, station)
  end

  def remove_station(station)
    return if [@stations.first, @stations.last].include?(station)

    @stations.delete(station)
  end
end
