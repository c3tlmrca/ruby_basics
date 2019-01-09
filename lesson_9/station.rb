require './instance_counter.rb'
require './validation.rb'
require './accessors.rb'

class Station
  include Validator
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :trains, :name

  validate :name, :presence
  validate :name, :format, NAME_FORMAT
  validate :name, :duplicate 

  NAME_FORMAT = /^\w+$/.freeze

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

  def each_train
    @trains.each { |train| yield(train) }
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
end
