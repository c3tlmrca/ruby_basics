require './instance_counter.rb'
require './validator.rb'

class Station
  include Validator
  include InstanceCounter
  attr_reader :trains, :name

  NAME_FORMAT = /^\w+$/.freeze
  EMPTY_NAME = 'Название станции не может быть пустым!'.freeze
  INVALID_NAME = 'Невалидное название.'.freeze
  ALREADY_EXIST = 'Станция с таким названием уже существует'.freeze

  @@stations = {}

  def self.all
    @@stations
  end

  def self.find(name)
    @@stations[name]
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations[name] = self
    register_instance
  end

  def trains_each
    @@stations.each do |var|
      yield(var) if block_given?
    end
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

  private

  def validate!
    raise EMPTY_NAME if @name.empty?
    raise INVALID_NAME if @name !~ NAME_FORMAT
    raise ALREADY_EXIST unless self.class.find(name).nil?
  end
end
