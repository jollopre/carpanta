require_relative 'base'
require_relative 'customers'
require_relative 'sessions'

module Carpanta
  module Controllers
    class Application < Base
      use Customers
      use Sessions
    end
  end
end
