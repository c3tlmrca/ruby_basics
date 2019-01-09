module Accessor
  def attr_accessor_with_hystory(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history_var = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        instance_variable_set(history_var, []) if instance_variable_get(history_var).nil?    
        instance_variable_get(history_var) << (instance_variable_get(var_name))
        instance_variable_set(var_name, value)
      end
      define_method("#{name}_history") { instance_variable_get(history_var) }
      end
    end
  end

  def strong_attr_accessor(name, type)
    var_name = "@#{name}".to_sym
    define_method(name.to_sym) { instance_variable_get(var_name) }
    define_method("#{name}=".to_sym) do |value|
      raise "Эта переменная может быть только #{type}." unless value.class.eql?(type)

      instance_variable_set(var_name, value)
    end
  end
end
