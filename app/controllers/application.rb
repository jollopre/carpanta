require_relative 'base'
require_relative 'customers'
require_relative 'appointments'

module Carpanta
  module Controllers
    class Application < Base
      use Appointments
      use Customers

      get '/' do
        redirect('/customers')
      end
    end
  end
end
