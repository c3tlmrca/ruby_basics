require './manufactured_by.rb'

class Car
  include ManufacturedBy
  attr_reader :added, :capacity, :id, :occupied_space

  INVALID_CAPACITY = 'Вместимость не может быть <= 0'.freeze
  INVALID_ID = 'Номер вагона должен содержать только буквы и цифры'.freeze
  VALID_ID = /^\w+$/.freeze
  NO_FREE_SPACE = 'Нет свободного места'.freeze
  NEGATIVE_OCCUPIED_SPACE = 'Загруженность вагона не может быть' \
  ' отрицательной'.freeze
  ALREADY_EXIST = 'Вагон с таким номером уже существует.'.freeze

  @@cars = {}

  def initialize(id, capacity, manufacturer = nil)
    @id = id
    @capacity = capacity
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

  private

  def validate!
    raise INVALID_CAPACITY unless capacity.positive?

    raise INVALID_ID if id !~ VALID_ID

    raise ALREADY_EXIST unless self.class.find(id).nil?
  end
end
