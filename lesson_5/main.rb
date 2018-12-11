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

  ENTER_ID_TRAIN = 'Укажите уникальный идентификационный номер поезда: '.freeze
  LIST_TRAINS = 'Список всех поездов: '.freeze
  ENTER_STATION_NAME = 'Введите название станции: '.freeze
  LIST_STATIONS = 'Список всех станций: '.freeze
  LIST_TRAINS_AT_STATION = 'Список поездов на текущей станции: '.freeze
  ENTER_FIRST_LAST_STATION_ON_ROUTE = 'Введите номера первой и последней станции в маршруте: '.freeze
  ENTER_STATION_ON_ROUTE = 'Введите имя станции: '.freeze
  LIST_ROUTES = 'Список всех маршрутов: '.freeze
  LIST_STATIONS_ON_ROUTE = 'Введите имя машрута (первая\последняя станция): '.freeze
  INVALID_INPUT = 'Неверный ввод. Попробуйте еще раз.'.freeze
  OBJECT_CREATED = 'Объект создан.'.freeze
  ENTER_TO_CONTINUE = 'Нажмите ENTER для продолжения...'.freeze
  NO_STATIONS = 'Станции еще не созданы.'.freeze
  NO_ROUTES = 'Маршруты еще не созданы.'.freeze
  NO_TRAINS = 'Поезда еще не созданы.'.freeze
  SAME_STATION = 'Эта станция уже присутствует в данном маршруте '.freeze
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
      print MAIN_MENU
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
      print TRAINS
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
      print STATIONS
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
      print ROUTES
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
    train = type.new(enter_train_id)
    @trains << train
    object_created
  end

  def create_station
    loop do
      station_name = enter_station_name
      next if station_name.nil? || station_exist?(station_name)

      station = Station.new(station_name)
      @stations << station
      object_created
      break
    end
  end

  def create_route
    loop do
      list_stations
      no_stations if @stations.empty?
      create_station if @stations.length < MINIMUM_ROUTE_LENGTH
      input = enter_first_last_stations
      route = Route.new(input)
      @routes << route
      object_created
      break
    end
  end

  def add_station_to_route
    list_stations
    list_routes
    current_route = choose_route
    current_station = loop do
                        station = choose_station
                        break station unless current_route.stations.include?(station)
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
    return no_cars if train.carriages_quantity.empty?
    return train_is_moving if train.speed.positive?

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
    route.print_stations
    ok
  end

  def print_trains_at_station
    list_stations
    station = choose_station
    puts NO_TRAINS_AT_STATION if station.trains.empty?
    station.print_trains
    ok
  end

  def no_cars
    puts 'У этого поезда нет вагонов!'
  end

  def train_is_moving
    puts 'Поезд движется!'
  end

  def ok
    puts 'OK'
  end

  def station_exist?(station_name)
    @stations.any? { |station| station.name == station_name }
  end

  def choose_route
    loop do
      print CHOOSE_ROUTE
      choice = gets.to_i - 1
      next puts INVALID_INPUT if choice.negative?

      break @routes[choice] if choice <= (@routes.length - 1)

      puts INVALID_INPUT
    end
  end

  def choose_station
    loop do
      print CHOOSE_STATION
      choice = gets.to_i - 1
      next puts(INVALID_INPUT) unless choise.between?(0, @stations.length - 1)

      break @stations[choice]

      puts INVALID_INPUT
    end
  end

  def choose_train
    loop do
      print CHOOSE_TRAIN
      choice = gets.to_i - 1
      next puts INVALID_INPUT if choice.negative?
      break @trains[choice] if choice <= (@trains.length - 1)

      puts INVALID_INPUT
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

  def list_trains
    no_trains if @trains.empty?
    puts 'Список поездов: '
    @trains.each.with_index(1) do |train, index|
      puts "#{index}. #{train.number}."
    end
  end

  def list_stations
    no_stations if @stations.empty?
    puts 'Список станций: '
    @stations.each.with_index(1) do |station, index|
      puts "#{index}. #{station.name}."
    end
  end

  def list_routes
    no_routes if @routes.empty?
    puts 'Список маршрутов: '
    @routes.each.with_index(1) do |route, index|
      puts "#{index}. #{route.print_stations}."
    end
  end

  def enter_first_last_stations
    loop do
      input = []
      puts ENTER_FIRST_LAST_STATION_ON_ROUTE
      gets.gsub(/\d+/) { |var| input << (var.to_i - 1) }
      next if input.length != MINIMUM_ROUTE_LENGTH

      stations = [@stations[input.first], @stations[input.last]]
      next puts INVALID_INPUT if stations.any?(&:nil?)

      break stations
    end
  end

  def not_station
    puts 'Это не станция/станции!'
  end

  def object_created
    puts OBJECT_CREATED
    puts ENTER_TO_CONTINUE
    gets
  end

  def enter_station_name
    loop do
      puts ENTER_STATION_NAME
      station_name = gets.strip.capitalize
      break station_name unless station_name.empty?
    end
  end

  def enter_train_id
    puts ENTER_ID_TRAIN
    gets.gsub(/[[:punct:]]/, '').delete(' ').strip
  end

  def invalid_input
    puts INVALID_INPUT
  end
end

main = Main.new
main.run_main
