require 'station'

class Route
  attr_reader :route

  def initialize(first_station, last_station)
    @route = [first_station, last_station]
    validate
  end

  def add_station(station)
    return unless station.is_a?(Station)

    @route.insert(@route[-2], station)
  end

  def rem_station(station)
    return if station == @route.first || station == @route.last

    @route.delete(station)
  end

  def print_stations
    @route.each.with_index(1) do |station, number|
      puts "#{number}. #{station}."
    end
  end

  private

  def validate
    raise 'Это не станция' unless @route.all? { |station| station.is_a?(Station) }
  end
end
