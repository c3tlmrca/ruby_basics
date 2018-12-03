class PassengerTrain < Train
  private

  def correct_car?(car)
    car.is_a?(PassengerCar)
  end
end
