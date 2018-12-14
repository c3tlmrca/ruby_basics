require './instance_counter.rb'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(stations)
    @stations = stations
    register_instance
  end

  def add_station(station)
    return unless station.is_a?(Station)

    @stations.insert(-2, station)
  end

  def remove_station(station)
    return if station == @stations.first || station == @stations.last

    @stations.delete(station)
  end

  def print_stations
    @stations.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}."
    end
  end
end
