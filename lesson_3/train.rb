require 'route'
require 'station'

class Train
  attr_reader :type, :quan_cars, :route, :speed

  def initialize(id, type, quan_cars)
    @id = id
    @type = type
    @quan_cars = quan_cars
    @speed = 0
    @route = nil
    validate
  end

  def incr_speed(number)
    @speed += number
  end

  def decr_speed(number)
    if (@speed - number).positive?
      @speed -= number
    else
      @speed = 0
    end
  end

  def add_car
    return unless @speed.zero?

    @quan_cars += 1
  end

  def remove_car
    return unless @speed.zero? || @quan_cars.positive?

    @quan_cars -= 1
  end

  def add_route(route)
    return unless route.is_a?(Route)

    @route = route
    @current_station = 0
    @route.route[0].add_train(self)
  end

  def current_station
    return if @route.nil?

    @route.route[@current_station]
  end

  def next_station
    return if @route.nil?

    @route.route[@current_station + 1]
  end

  def previous_station
    return if @route.nil?

    @route.route[@current_station - 1] if @current_station.positive?
  end

  def go_to_next_station
    return if @route.nil? || @current_station == @route.route.length - 1

    current_station.remove_train(self)
    @current_station += 1
    current_station.add_train(self)
  end

  def go_to_previous_station
    return if @route.nil? || @current_station.zero?

    current_station.remove_train(self)
    @current_station -= 1
    current_station.add_train(self)
  end

  private

  def validate
    raise ArgumentError, 'Кол-во вагонов не должно быть < 0' if @quan_cars.negative?
  end
end
