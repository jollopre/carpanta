require 'lib/configurable'

module Carpanta
  include Configurable

  configure_with :root, :environment, :logger
  DEVELOPMENT_ENVIRONMENTS = ['development', 'test'].freeze

  class << self
    def method_missing(method, *args, &block)
      return configuration.send(method, *args, &block) if configuration.respond_to?(method)

      super(method, *args, &block)
    end

    def development?
      DEVELOPMENT_ENVIRONMENTS.include?(configuration.environment)
    end
  end
end
