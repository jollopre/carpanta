require "delegate"
require "logger"

module Infra
  class Logger < SimpleDelegator
    class << self
      def build
        new(::Logger.new($stdout))
      end
    end

    private_class_method :new
  end
end
