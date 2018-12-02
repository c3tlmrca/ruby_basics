class Route
  attr_reader :stations

  def initialize(first_station, last_station)
    @stations = [first_station, last_station]
    validate!
  end

  def add_station(station)
    return unless station.is_a?(Station)

    @stations.insert(-2, station)
  end

  def rem_station(station)
    return if station == @stations.first || station == @stations.last

    @stations.delete(station)
  end

  def print_stations
    @stations.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}."
    end
  end

  private

  def validate!
    raise 'Это не станция' unless @stations.all? { |station| station.is_a?(Station) }
  end
end
