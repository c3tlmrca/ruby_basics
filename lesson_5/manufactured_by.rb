module ManufacturedBy
  attr_reader :manufacturer

  protected

  def manufacturer=(name)
    @manufacturer = name
  end
end
