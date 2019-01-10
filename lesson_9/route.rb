require './instance_counter.rb'
require './validation.rb'
require './accessors.rb'

class Route
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :stations

  validate :first_station, :type, Station
  validate :last_station, :type, Station

  def initialize(stations)
    @stations = stations
    @first_station = @stations.first
    @last_station = @stations.last
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
