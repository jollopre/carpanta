module Carpanta
  module Domain
    module Customers
      class InvalidCustomer < StandardError ; end
      class EmailNotUnique < StandardError ; end
    end
  end
end
