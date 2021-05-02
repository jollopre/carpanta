require_relative "base"
require_relative "customers"
require_relative "calendar"

module Carpanta
  module Controllers
    class Application < Base
      use Customers
      use Calendar

      get "/" do
        redirect("/customers")
      end
    end
  end
end
