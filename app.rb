require "lib/configurable"

module Carpanta
  DELEGATED_METHODS = [:root, :environment, :logger]
  include Configurable

  configure_with(*DELEGATED_METHODS)

  class << self
    def method_missing(name, *args, &block)
      return super unless DELEGATED_METHODS.include?(name)

      configuration.send(name, *args, &block)
    end

    def respond_to_missing?(name, include_private = false)
      DELEGATED_METHODS.include?(name) or super
    end
  end
end
