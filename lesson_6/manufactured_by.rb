module ManufacturedBy
  attr_reader :manufacturer

  MANUFACTURER_NAME_FORMAT = /^\w+$/.freeze
  INVALID_MANUFACTURER_NAME = 'Название производителя должно состоять из букв\цифр.'.freeze

  protected

  def manufacturer=(name)
    @manufacturer = name
    validate_manufacturer!
  end

  def validate_manufacturer!
    raise INVALID_MANUFACTURER_NAME if @manufacturer !~ MANUFACTURER_NAME_FORMAT
  end
end
