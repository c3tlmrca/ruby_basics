module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances
      @instances = instances || 0
    end

    protected

    def add_instance
      @instances = instances + 1
    end
  end

  module InstanceMethods
    protected

    def reg_instance
      add_instance
    end
  end
end
