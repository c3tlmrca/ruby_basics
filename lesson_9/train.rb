require './instance_counter.rb'
require './manufactured_by.rb'
require './validation.rb'
require './accessors.rb'

class Train
  include InstanceCounter
  include ManufacturedBy
  include Validation
  extend Accessors

  attr_reader :type, :carriages_quantity, :speed, :number

  attr_accessor_with_history :route

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  validate :number, :duplicate 
  
  NUMBER_FORMAT = /^\w{3}-?\w{2}$/i.freeze


  @@trains = {}

  def initialize(number, manufacturer = nil)
    @number = number
    @carriages_quantity = []
    @speed = 0
    @route = nil
    self.manufacturer = manufacturer
    validate!
    @@trains[number] = self
    register_instance
  end

  def self.find(number)
    @@trains[number]
  end

  def each_car
    @carriages_quantity.each { |car| yield(car) }
  end

  def increase_speed(number)
    @speed += number
  end

  def decrease_speed(number)
    if (@speed - number).positive?
      @speed -= number
    else
      @speed = 0
    end
  end

  def add_car(car)
    return unless @speed.zero? && correct_car?(car)

    @carriages_quantity << car
  end

  def remove_car
    @carriages_quantity.pop
  end

  def add_route(route)
    return unless route.is_a?(Route)

    @route = route
    @current_station = 0
    @route.stations[0].add_train(self)
  end

  def remove_route(route)
    return if route.nil?

    route.stations.each { |station| station.remove_train(self) }
  end

  def current_station
    return if @route.nil?

    @route.stations[@current_station]
  end

  def next_station
    return if @route.nil?

    @route.stations[@current_station + 1]
  end

  def previous_station
    return if @route.nil?

    @route.stations[@current_station - 1] if @current_station.positive?
  end

  def go_to_next_station
    return if @route.nil? || next_station.nil?

    current_station.remove_train(self)
    @current_station += 1
    current_station.add_train(self)
  end

  def go_to_previous_station
    return if @route.nil? || previous_station.nil?

    current_station.remove_train(self)
    @current_station -= 1
    current_station.add_train(self)
  end
end
