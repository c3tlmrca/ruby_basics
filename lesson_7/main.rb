require './car.rb'
require './train.rb'
require './station.rb'
require './route.rb'
require './cargo_car.rb'
require './cargo_train.rb'
require './passenger_car.rb'
require './passenger_train.rb'

class Main
  MAIN_MENU = <<-DOC.freeze
  1. Поезда.
  2. Вагоны.
  3. Станции.
  4. Маршруты.
  5. Выход.
  DOC

  TRAINS = <<-DOC.freeze
  1. Создать грузовой поезд.
  2. Создать пассажирский поезд.
  3. Просмотреть список поездов.
  4. Назад.
  DOC

  CARS = <<-DOC.freeze
  1. Создать и добавить вагон к поезду.
  2. Отцепить вагон от поезда.
  3. Вывести список вагонов поезда.
  4. Занять место/объем в вагоне.
  5. Освободить место/объем в вагоне.
  6. Назад.
  DOC

  STATIONS = <<-DOC.freeze
  1. Создать станцию.
  2. Просмотреть список всех станций.
  3. Просмотреть список поездов на станции.
  4. Назад.
  DOC

  ROUTES = <<-DOC.freeze
  1. Создать маршрут.
  2. Добавить маршрут к поезду.
  3. Добавить станцию в машрут.
  4. Удалить станцию из маршрута.
  5. Просмотреть список машрутов.
  6. Просмотреть список станций в маршруте.
  7. Переместить поезд по маршруту вперед.
  8. Переместить поезд по маршруту назад.
  9. Назад.
  DOC

  ENTER_ID_TRAIN = 'Укажите уникальный идентификационный номер поезда (формата XXX-XX): '.freeze
  LIST_TRAINS = 'Список всех поездов: '.freeze
  ENTER_STATION_NAME = 'Введите название станции (цифры и буквы): '.freeze
  LIST_STATIONS = 'Список всех станций: '.freeze
  LIST_TRAINS_AT_STATION = 'Список поездов на текущей станции: '.freeze
  ENTER_FIRST_LAST_STATION_ON_ROUTE = 'Введите номера первой и последней станции в маршруте: '.freeze
  ENTER_STATION_ON_ROUTE = 'Введите имя станции в этом маршруте: '.freeze
  ENTER_MANUFACTURER = 'Введите имя производителя (буквы и цифры): '.freeze
  ENTER_CAR_NUMBER = 'Введите номер вагона: '.freeze
  ENTER_INDEX_CAR = 'Введите порядковый номер вагона: '.freeze
  ENTER_VALUE_UPLOAD = 'Введите кол-во занимаемых мест/занимаемого объема: '.freeze
  ENTER_VALUE_OFFLOAD = 'Введите кол-во освобождаемых мест/освобождаемого объема: '.freeze
  ENTER_CAPACITY = 'Введите кол-во мест(для пассажирских вагонов), объем(для грузовых): '.freeze
  LIST_ROUTES = 'Список всех маршрутов: '.freeze
  LIST_STATIONS_ON_ROUTE = 'Введите имя машрута (первая\последняя станция): '.freeze
  INVALID_INPUT = 'Неверный ввод. Попробуйте еще раз.'.freeze
  OBJECT_CREATED = 'Объект создан.'.freeze
  ENTER_TO_CONTINUE = 'Нажмите ENTER для продолжения...'.freeze
  NO_STATIONS = 'Станции еще не созданы.'.freeze
  NO_ROUTES = 'Маршруты еще не созданы.'.freeze
  NO_TRAINS = 'Поезда еще не созданы.'.freeze
  SAME_STATION = 'Эта станция уже присутствует в данном маршруте.'.freeze
  STATION_ALREADY_EXIST = 'Станция с этим названием уже существует.'.freeze
  STATION_ALREADY_EXIST_IN_ROUTE = 'Такая станция уже присутствует в маршруте'.freeze
  CHOOSE_STATION = 'Введите номер станции из списка: '.freeze
  CHOOSE_ROUTE = 'Введите номер маршрута из списка: '.freeze
  CHOOSE_TRAIN = 'Введите номер поезда из списка: '.freeze
  NO_TRAINS_AT_STATION = 'На этой станции нет поездов.'.freeze
  CAR_NOT_EXIST = 'Такого вагона не существует.'.freeze
  MINIMUM_ROUTE_LENGTH = 2

  def run_main
    main_menu
  end

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  private

  def main_menu
    loop do
      puts MAIN_MENU
      input = gets.to_i
      case input
      when 1 then trains
      when 2 then cars
      when 3 then stations
      when 4 then routes
      when 5 then exit
      else invalid_input
      end
    end
  end

  def trains
    loop do
      puts TRAINS
      input = gets.to_i
      case input
      when 1 then create_train(CargoTrain)
      when 2 then create_train(PassengerTrain)
      when 3 then list_trains
      when 4 then break
      else invalid_input
      end
    end
  end

  def cars
    loop do
      puts CARS
      input = gets.to_i
      case input
      when 1 then add_cars
      when 2 then remove_cars
      when 3 then print_cars
      when 4 then add_load_car
      when 5 then remove_load_car
      when 6 then break
      else invalid_input
      end
    end
  end

  def stations
    loop do
      puts STATIONS
      input = gets.to_i
      case input
      when 1 then create_station
      when 2 then list_stations
      when 3 then print_trains_at_station
      when 4 then break
      else invalid_input
      end
    end
  end

  def routes
    loop do
      puts ROUTES
      input = gets.to_i
      case input
      when 1 then create_route
      when 2 then add_route_to_train
      when 3 then add_station_to_route
      when 4 then remove_station_from_route
      when 5 then list_routes
      when 6 then print_stations_on_route
      when 7 then go_train_to_next_station
      when 8 then go_train_to_previous_station
      when 9 then break
      else invalid_input
      end
    end
  end

  def create_train(type)
    begin
      train = type.new(enter_train_id, enter_manufacturer_name)
    rescue RuntimeError => e
      puts "Ошибка: #{e.message}"
      retry
    end
    @trains << train
    train_created(type, train)
  end

  def create_station
    begin
      station_name = enter_station_name
      return station_already_exist(station_name) if station_exist?(station_name)

      station = Station.new(station_name)
    rescue RuntimeError => e
      puts "Ошибка: #{e.message}"
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
    object_created
  end

  def add_station_to_route
    list_stations
    list_routes
    current_route = choose_route
    current_station = nil
      begin
        station = choose_station
        raise station_already_exist_in_route(station, current_route) if current_route.stations.include?(station)
      rescue StandardError
        retry
      ensure current_station = station
      end
    current_route.add_station(current_station)
    ok
  end

  def remove_station_from_route
    list_stations
    list_routes
    current_route = choose_route
    loop do
      current_station = choose_station
      next unless current_route.stations.include?(current_station)
      break unless current_route.remove_station(current_station).nil?
    end
    ok
  end

  def add_cars
    list_trains
    train = choose_train
    begin
      car = if train.is_a?(CargoTrain)
              CargoCar.new(enter_car_number, enter_capacity)
            else
              PassengerCar.new(enter_car_number, enter_capacity)
            end
    rescue StandardError
      retry
    end
    train.add_car(car)
    ok
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
      puts "#{e.message}"
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
      puts "#{e.message}"
      retry
    end
    ok
  end

  def choose_cars
    train = print_cars
    begin
      choose_car = enter_index_number_of_car
      raise CAR_NOT_EXIST if train.carriages_quantity[choose_car].nil?
    rescue StandardError
      retry
    ensure return train.carriages_quantity[choose_car]
    end
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
    loop do
      choice = print_choose_train
      next invalid_input if choice.negative?
      break @trains[choice] if choice <= (@trains.length - 1)

      invalid_input
    end
  end

  def list_trains
    no_trains if @trains.empty?
    puts LIST_TRAINS
    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}, #{train.class}, #{train.carriages_quantity.length}."
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
    puts "#{station.name} уже существует."
  end

  def station_already_exist_in_route(station, route)
    puts "#{station.name} уже есть в #{route}."
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
