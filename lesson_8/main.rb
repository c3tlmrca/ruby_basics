require './car.rb'
require './train.rb'
require './station.rb'
require './route.rb'
require './cargo_car.rb'
require './cargo_train.rb'
require './passenger_car.rb'
require './passenger_train.rb'

class Main
  TRAIN_TYPE = <<-DOC.freeze
  1. Пассажирский поезд.
  2. Грузовой поезд.
  DOC

  ENTER_ID_TRAIN = 'Укажите уникальный идентификационный' \
  ' номер поезда (формата XXX-XX): '.freeze
  PASSENGER = 1
  LIST_TRAINS = 'Список всех поездов: '.freeze
  ENTER_STATION_NAME = 'Введите название станции (цифры и буквы): '.freeze
  LIST_STATIONS = 'Список всех станций: '.freeze
  LIST_TRAINS_AT_STATION = 'Список поездов на текущей станции: '.freeze
  ENTER_FIRST_LAST_STATION_ON_ROUTE = 'Введите номера первой и' \
  ' последней станции в маршруте: '.freeze
  ENTER_STATION_ON_ROUTE = 'Введите имя станции в этом маршруте: '.freeze
  ENTER_MANUFACTURER = 'Введите имя производителя (буквы и цифры): '.freeze
  ENTER_CAR_NUMBER = 'Введите номер вагона: '.freeze
  ENTER_INDEX_CAR = 'Введите порядковый номер вагона: '.freeze
  ENTER_VALUE_UPLOAD = 'Введите кол-во занимаемых мест/занимаемого' \
  ' объема: '.freeze
  ENTER_VALUE_OFFLOAD = 'Введите кол-во освобождаемых мест/освобождаемого' \
  ' объема: '.freeze
  ENTER_CAPACITY = 'Введите кол-во мест(для пассажирских вагонов),' \
  ' объем(для грузовых): '.freeze
  LIST_ROUTES = 'Список всех маршрутов: '.freeze
  LIST_STATIONS_ON_ROUTE = 'Введите имя машрута (первая\последняя' \
  ' станция): '.freeze
  INVALID_INPUT = 'Неверный ввод. Попробуйте еще раз.'.freeze
  OBJECT_CREATED = 'Объект создан.'.freeze
  ENTER_TO_CONTINUE = 'Нажмите ENTER для продолжения...'.freeze
  NO_STATIONS = 'Станции еще не созданы.'.freeze
  NO_ROUTES = 'Маршруты еще не созданы.'.freeze
  NO_TRAINS = 'Поезда еще не созданы.'.freeze
  SAME_STATION = 'Эта станция уже присутствует в данном маршруте.'.freeze
  STATION_ALREADY_EXIST = 'Станция с этим названием уже существует.'.freeze
  STATION_ALREADY_EXIST_IN_ROUTE = 'Такая станция уже присутствует' \
  ' в маршруте'.freeze
  CHOOSE_STATION = 'Введите номер станции из списка: '.freeze
  CHOOSE_ROUTE = 'Введите номер маршрута из списка: '.freeze
  CHOOSE_TRAIN = 'Введите номер поезда из списка: '.freeze
  NO_TRAINS_AT_STATION = 'На этой станции нет поездов.'.freeze
  CAR_NOT_EXIST = 'Такого вагона не существует.'.freeze
  BREAK = 9
  EXIT = 10
  MINIMUM_ROUTE_LENGTH = 2
  VALID_VARIANTS = (1..2).freeze

  TRAINS_ARRAY = [
    { text: '1. Создать поезд.', handler: :create_train },
    { text: "2. Просмотреть список поездов.\n9. Назад.", handler: :list_trains }
  ].freeze

  CARS_ARRAY = [
    { text: '1. Прицепить вагон.', handler: :add_cars },
    { text: '2. Отцепить вагон.', handler: :remove_cars },
    { text: '3. Просмотреть список вагонов', handler: :print_cars },
    { text: '4. Занять место/объем в вагоне.', handler: :add_load_car },
    { text: "5. Освободить место/объем в вагоне.\n9. Назад.", \
      handler: :remove_load_car }
  ].freeze

  STATIONS_ARRAY = [
    { text: '1. Создать станцию.', handler: :create_station },
    { text: '2. Просмотреть список станций.', handler: :list_stations },
    { text: "3. Просмотреть список поездов на станции.\n9. Назад.", \
      handler: :print_trains_at_station }
  ].freeze

  ROUTES_ARRAY = [
    { text: '1. Создать маршрут.', handler: :create_route },
    { text: '2. Добавить маршрут к поезду.', handler: :add_route_to_train },
    { text: '3. Добавить станцию в маршрут.', handler: :add_station_to_route },
    { text: '4. Удалить станцию из маршрута.', \
      handler: :remove_station_from_route },
    { text: '5. Список маршрутов.', handler: :list_routes },
    { text: '6. Список станций в маршруте.', \
      handler: :print_stations_on_route },
    { text: '7. Переместить поезд по маршруту вперед.', \
      handler: :go_train_to_next_station },
    { text: "8. Переместить поезд по маршруту назад.\n9. Назад.", \
      handler: :go_train_to_previous_station }
  ].freeze

  MAIN_MENU_ARRAY = [
    { text: '1. Поезда.', handler: TRAINS_ARRAY },
    { text: '2. Станции.', handler: CARS_ARRAY },
    { text: '3. Вагоны.', handler: STATIONS_ARRAY },
    { text: '4. Маршруты.', handler: ROUTES_ARRAY },
    { text: '10. Выход.' }
  ].freeze

  def run_main
    main(MAIN_MENU_ARRAY)
  end

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  private

  def main(array)
    loop do
      array.each { |hash| puts hash[:text] }
      input = gets.to_i

      break if input.equal?(BREAK)

      exit if input.equal?(EXIT)

      next send(:invalid_input) if \
      array[input - 1].nil? || input.zero? || input.negative?

      next send(array[input - 1][:handler]) if \
      (array[input - 1][:handler]).is_a?(Symbol)

      main(array[input - 1][:handler])
    end
  end

  def create_train
    begin
      train = choose_train_type.new(enter_train_id, enter_manufacturer_name)
    rescue RuntimeError => e
      puts e.message.to_s
      retry
    end
    @trains << train
    train_created(train.class, train)
  end

  def create_station
    begin
      station_name = enter_station_name
      return station_already_exist(station_name) if station_exist?(station_name)

      station = Station.new(station_name)
    rescue RuntimeError => e
      puts e.message.to_s
      retry
    end
    @stations << station
    object_created
  end

  def create_route
    list_stations
    no_stations if @stations.empty?
    create_station if @stations.length < MINIMUM_ROUTE_LENGTH
    begin
      input = enter_first_last_stations
      route = Route.new(input)
    rescue StandardError
      retry
    end
    @routes << route
  end

  def add_station_to_route
    list_stations
    list_routes
    current_route = choose_route
    current_route.add_station(choose_current_station(current_route))
  end

  def choose_current_station(current_route)
    begin
      station = choose_station
      raise station_already_exist_in_route(station, current_route) \
      if current_route.stations.include?(station)
    rescue StandardError
      retry
    end
    station
  end

  def remove_station_from_route
    list_stations
    list_routes
    current_route = choose_route
    current_route.remove_station(current_station(current_route))
  end

  def current_station(route)
    begin
      current_station = choose_station
      raise invalid_input unless \
      route.stations.include?(current_station)
      raise invalid_input if \
      route.remove_station(current_station).nil?
    rescue StandardError
      retry
    end
    current_station
  end

  def add_cars
    list_trains
    train = choose_train
    begin
      car = type_car(train)
    rescue StandardError
      retry
    end
    train.add_car(car)
  end

  def type_car(train)
    if train.is_a?(CargoTrain)
      CargoCar.new(enter_car_number, enter_capacity)
    else
      PassengerCar.new(enter_car_number, enter_capacity)
    end
  end

  def remove_cars
    list_trains
    train = choose_train
    return no_cars(train) if train.carriages_quantity.empty?
    return train_is_moving(train) if train.speed.positive?

    train.remove_car
    ok
  end

  def add_load_car
    car = choose_cars
    return car.add if car.is_a?(PassengerCar)

    begin
      value = enter_value_upload
      car.add(value)
    rescue StandardError => e
      puts e.message.to_s
      retry
    end
    ok
  end

  def remove_load_car
    car = choose_cars
    return car.remove if car.is_a?(PassengerCar)

    begin
      value = enter_value_offload
      car.remove(value)
    rescue StandardError => e
      puts e.message.to_s
      retry
    end
    ok
  end

  def choose_cars
    train = print_cars
    begin
      choose_car = enter_index_number_of_car
      raise CAR_NOT_EXIST if train.carriages_quantity[choose_car].nil?
    rescue StandardError => e
      puts e.message.to_s
      retry
    end
    train.carriages_quantity[choose_car]
  end

  def go_train_to_next_station
    list_trains
    train = choose_train
    add_route_to_train if train.route.nil?
    train.go_to_next_station
    ok
  end

  def go_train_to_previous_station
    list_trains
    train = choose_train
    add_route_to_train if train.route.nil?
    train.go_to_previous_station
    ok
  end

  def add_route_to_train
    list_trains
    list_routes
    train = choose_train
    route = choose_route
    train.remove_route(train.route)
    train.add_route(route)
    ok
  end

  def print_stations_on_route
    list_routes
    route = choose_route
    print_stations(route)
    ok
  end

  def print_trains_at_station
    list_stations
    station = choose_station
    no_trains_at_station(station) if station.trains.empty?
    print_trains(station)
    ok
  end

  def print_cars
    list_trains
    train = choose_train
    add_cars if train.carriages_quantity.empty?
    train.each_car do |car|
      print "\nВагон с номером: #{car.id}, "
      print "#{car.class}, "
      print "занято: #{car.current_load_space} "
      puts "свободно: #{car.current_free_space}."
    end
    train
  end

  def station_exist?(station_name)
    @stations.any? { |station| station.name == station_name }
  end

  def choose_route
    loop do
      choice = print_choose_route
      next invalid_input if choice.negative?

      break @routes[choice] if choice <= (@routes.length - 1)

      invalid_input
    end
  end

  def choose_station
    choice = print_choose_station

    @stations[choice]
  end

  def choose_train
    begin
      choice = print_choose_train
      raise invalid_input if choice.negative?
      raise invalid_input unless choice <= (@trains.length - 1)
    rescue StandardError
      retry
    end
    @trains[choice]
  end

  def choose_train_type
    loop do
      puts TRAIN_TYPE
      input = gets.to_i
      next INVALID_INPUT unless VALID_VARIANTS.include?(input)

      input.equal?(PASSENGER) ? (return PassengerTrain) : (return CargoTrain)
    end
  end

  def list_trains
    no_trains if @trains.empty?
    puts LIST_TRAINS
    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}, #{train.class}," \
      " #{train.carriages_quantity.length}."
    end
  end

  def list_stations
    no_stations if @stations.empty?
    puts LIST_STATIONS
    @stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}."
    end
  end

  def list_routes
    no_routes if @routes.empty?
    puts LIST_ROUTES
    @routes.each.with_index(1) do |route, index|
      puts "#{index}. #{route.first_station.name} - #{route.last_station.name}."
    end
  end

  def print_choose_station
    puts CHOOSE_STATION
    gets.to_i - 1
  end

  def print_choose_route
    puts CHOOSE_ROUTE
    gets.to_i - 1
  end

  def print_choose_train
    puts CHOOSE_TRAIN
    gets.to_i - 1
  end

  def print_stations(route)
    route.stations.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}."
    end
  end

  def print_trains(station)
    station.each_train do |train|
      print "\n#{train.number}, "
      print " #{train.class}, "
      print "#{train.carriages_quantity.length}.\n"
    end
  end

  def enter_station_name
    puts ENTER_STATION_NAME
    gets.chomp.delete(' ', '').capitalize
  end

  def enter_index_number_of_car
    puts ENTER_INDEX_CAR
    gets.to_i - 1
  end

  def enter_car_number
    puts ENTER_CAR_NUMBER
    gets.strip
  end

  def enter_capacity
    puts ENTER_CAPACITY
    gets.to_i
  end

  def enter_value_upload
    puts ENTER_VALUE_UPLOAD
    gets.to_i
  end

  def enter_value_offload
    puts ENTER_VALUE_OFFLOAD
    gets.to_i
  end

  def enter_first_last_stations
    loop do
      input = []
      puts ENTER_FIRST_LAST_STATION_ON_ROUTE
      gets.gsub(/\d+/) { |var| input << (var.to_i - 1) }
      next if input.length != MINIMUM_ROUTE_LENGTH

      stations = [@stations[input.first], @stations[input.last]]

      break stations
    end
  end

  def no_stations
    puts NO_STATIONS
    create_station
  end

  def no_routes
    puts NO_ROUTES
    create_route
  end

  def no_trains
    puts NO_TRAINS
    create_train
  end

  def train_created(type, train)
    puts "#{type} с номером: #{train.number} был создан."
  end

  def object_created
    puts OBJECT_CREATED
    puts ENTER_TO_CONTINUE
    gets
  end

  def enter_train_id
    puts ENTER_ID_TRAIN
    gets.strip
  end

  def enter_manufacturer_name
    puts ENTER_MANUFACTURER
    gets.chomp.delete(' ', '')
  end

  def station_already_exist(station)
    puts "#{station} уже существует."
  end

  def station_already_exist_in_route(station, route)
    puts "#{station} уже есть в #{route}."
  end

  def no_cars(train)
    puts "У #{train.number} нет вагонов."
  end

  def train_is_moving(train)
    puts "#{train.number} движется."
  end

  def no_trains_at_station(station)
    puts "На станции #{station.name} нет поездов."
  end

  def invalid_input
    puts INVALID_INPUT
    gets
  end

  def ok
    puts 'Ok.'
  end
end

main = Main.new
main.run_main
