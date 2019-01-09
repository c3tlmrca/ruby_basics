require './manufactured_by.rb'
require './validation.rb'
require './accessors.rb'

class Car
  include ManufacturedBy
  include Validation
  extend Accessors

  attr_reader :added, :capacity, :id

  attr_accessor_with history :occupied_space

  validate :id, :presence
  validate :id, :format, VALID_ID
  validate :id, :duplicate
  validate :capacity, :positive

  VALID_ID = /^\w+$/.freeze
  NO_FREE_SPACE = 'Нет свободного места'.freeze
  NEGATIVE_OCCUPIED_SPACE = 'Загруженность вагона не может быть' \
  ' отрицательной'.freeze

  @@cars = {}

  def initialize(id, capacity, manufacturer = nil)
    @id = id
    @capacity = capacity.to_f
    @occupied_space = 0
    @added = false
    self.manufacturer = manufacturer
    validate!
    @@cars[id] = self
  end

  def self.find(number)
    @@cars[number]
  end

  def add(value)
    raise NO_FREE_SPACE if value > current_free_space

    @occupied_space += value
  end

  def remove(value)
    raise NEGATIVE_OCCUPIED_SPACE if (@occupied_space - value).negative?

    @occupied_space -= value
  end

  def current_load_space
    @occupied_space
  end

  def current_free_space
    @capacity - @occupied_space
  end

  def add_car!
    @added = true unless added?
  end

  def remove_car!
    @added = false if added?
  end

  def added?
    @added
  end
end
