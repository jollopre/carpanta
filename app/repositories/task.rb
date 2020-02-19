require_relative 'base'
require 'lib/configurable'

module Carpanta
  module Repositories
    class Task
      extend Base
      include Configurable
      configure_with :storage
    end
  end
end
