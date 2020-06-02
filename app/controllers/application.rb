require_relative 'base'
require_relative 'customers'

module Carpanta
  module Controllers
    class Application < Base
      use Customers

      get '/' do
        redirect('/customers')
      end
    end
  end
end
