require_relative 'base'
require_relative 'customers'

module Carpanta
  module Controllers
    class Application < Base
      use Customers
    end
  end
end
