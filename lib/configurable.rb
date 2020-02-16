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
        singleton_class.send(:attr_accessor, attr)
      end
    end
  end
end
