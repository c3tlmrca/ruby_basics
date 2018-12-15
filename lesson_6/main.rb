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
    2. Станции.
    3. Маршруты.
    4. Выход
  DOC

  TRAINS = <<-DOC.freeze
    1. Создать грузовой поезд.
    2. Создать пассажирский поезд.
    3. Просмотреть список поездов.
    4. Прицепить вагон.
    5. Отцепить вагон.
    6. Добавить маршрут.
    7. Назад.
  DOC

  STATIONS = <<-DOC.freeze
    1. Создать станцию
    2. Просмотреть список всех станций.
    3. Просмотреть список поездов на станции.
    4. Назад.
  DOC

  ROUTES = <<-DOC.freeze
    1. Создать маршрут
    2. Добавить станцию в машрут.
    3. Удалить станцию из маршрута.
    4. Просмотреть список машрутов.
    5. Просмотреть список станций в маршруте
    6. Переместить поезд по маршруту вперед.
    7. Переместить поезд по маршруту назад.
    8. Назад.
  DOC

  ENTER_ID_TRAIN = 'Укажите уникальный идентификационный номер поезда (формата XXX-XX): '.freeze
  LIST_TRAINS = 'Список всех поездов: '.freeze
  ENTER_STATION_NAME = 'Введите название станции (цифры и буквы): '.freeze
  LIST_STATIONS = 'Список всех станций: '.freeze
  LIST_TRAINS_AT_STATION = 'Список поездов на текущей станции: '.freeze
  ENTER_FIRST_LAST_STATION_ON_ROUTE = 'Введите номера первой и последней станции в маршруте: '.freeze
  ENTER_STATION_ON_ROUTE = 'Введите имя станции в этом маршруте: '.freeze
  ENTER_MANUFACTURER = 'Введите имя производителя (буквы и цифры): '.freeze
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
      when 2 then stations
      when 3 then routes
      when 4 then exit
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
      when 4 then add_car
      when 5 then remove_car
      when 6 then add_route_to_train
      when 7 then main_menu
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
      when 4 then main_menu
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
      when 2 then add_station_to_route
      when 3 then remove_station_from_route
      when 4 then list_routes
      when 5 then print_stations_on_route
      when 6 then go_train_to_next_station
      when 7 then go_train_to_previous_station
      when 8 then main_menu
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
    current_station =
      begin
        station = choose_station
        raise station_already_exist_in_route(station, current_route) if current_route.stations.include?(station)
      rescue StandardError
        retry
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

  def add_car
    list_trains
    train = choose_train
    car = if train.is_a?(CargoTrain)
            CargoCar.new
          else
            PassengerCar.new
          end
    train.add_car(car)
    ok
  end

  def remove_car
    list_trains
    train = choose_train
    return no_cars(train) if train.carriages_quantity.empty?
    return train_is_moving(train) if train.speed.positive?

    train.remove_car
    ok
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

  def station_exist?(station_name)
    @stations.any? { |station| station.name == station_name }
  end

  def choose_route
    loop do
      print_choose_route
      choice = gets.to_i - 1
      next invalid_input if choice.negative?

      break @routes[choice] if choice <= (@routes.length - 1)

      invalid_input
    end
  end

  def choose_station
    print_choose_station
    choice = gets.to_i - 1

    @stations[choice]
  end

  def choose_train
    loop do
      print_choose_train
      choice = gets.to_i - 1
      next invalid_input if choice.negative?
      break @trains[choice] if choice <= (@trains.length - 1)

      invalid_input
    end
  end

  def list_trains
    no_trains if @trains.empty?
    puts LIST_TRAINS
    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}."
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
      puts "#{index}. #{route}."
    end
  end

  def print_stations(route)
    route.stations.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}."
    end
  end

  def print_trains(station)
    station.trains.each.with_index(1) do |train, number|
      puts "#{number}. #{train.number} - #{train.type}."
    end
  end

  def enter_station_name
    puts ENTER_STATION_NAME
    gets.chomp.gsub(' ', '').capitalize
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
    gets.chomp.gsub(' ', '')
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
end

main = Main.new
main.run_main
