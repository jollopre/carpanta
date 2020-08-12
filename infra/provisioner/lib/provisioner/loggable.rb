require 'logger'

module Provisioner
  module Loggable
    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
