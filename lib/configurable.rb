module Configurable
  class << self
    def included(base)
      base.extend(ClassMethods)
    end
  end

  module ClassMethods
    def configure_with(*attributes)
      @configuration ||= Configuration.new(attributes)
    end

    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end

  class Configuration
    def initialize(attributes = [])
      attributes.each do |attr|
        puts "respond_to?(#{attr}): #{respond_to?(attr)}"
        singleton_class.send(:attr_accessor, attr)
      end
    end
    puts Configuration.singleton_methods
  end
end
