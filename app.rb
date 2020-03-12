require 'lib/configurable'

module Carpanta
  include Configurable

  configure_with :root, :environment, :logger

  class << self
    def method_missing(method, *args, &block)
      return configuration.send(method, *args, &block) if configuration.respond_to?(method)

      super(method, *args, &block)
    end
  end
end
