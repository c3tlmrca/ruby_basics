module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods

    base.instance_variable_set(:@validation, {})
  end

  module ClassMethods
    attr_reader :validation

    def validate(attr, type, arg = nil)
      @validation[attr] ||= {}
      @validation[attr][type] = arg
    end
  end

  module InstanceMethods
    def validate!
      self.class.validation.each do |attr, validation_type|
        validation_type.each do |type, arg|
          value = instance_variable_get("@#{attr}")
          send("validate_#{type}", value, arg)
        end
      end
    end

    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    private

    def validate_presence(attribute, _)
      raise 'Аттрибут не существует или является пустой строкой.' if attribute.nil? || attribute.empty?
    end

    def validate_format(attribute, format)
      raise "Аттрибут #{attribute} не соответствует формату #{format}." if attribute !~ format
    end

    def validate_type(attribute, type)
      raise "Аттрибут #{attribute.class} не соответствует указанному типу #{type}." unless attribute.is_a?(type)
    end

    def validate_duplicate(attribute, _)
      raise "Такой объект #{attribute} уже существует." unless self.class.find(attribute).nil?
    end

    def validate_positive(attribute, _)
      raise "#{attribute} не может быть отрицательным." unless attribute.positive?
    end
  end
end
