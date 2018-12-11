module ManufacturedBy
  attr_reader :manufacturer

  protected

  def manufactured=(name)
    @manufacturer = name
  end
end
