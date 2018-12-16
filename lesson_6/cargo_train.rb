class CargoTrain < Train
  private

  def correct_car?(car)
    car.is_a?(CargoCar)
  end
end
