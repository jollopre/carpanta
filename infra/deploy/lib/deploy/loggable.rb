require 'logger'

module Deploy
  module Loggable
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
