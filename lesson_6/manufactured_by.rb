module ManufacturedBy
  attr_reader :manufacturer

  protected

  def manufacturer=(name)
    validate!(name)
    @manufacturer = name
  end

  def validate!(name)
    raise 'Название производителя должно состоять из букв\цифр.' if /^[\w]{1,}$/.match(name).nil?
  end
end
