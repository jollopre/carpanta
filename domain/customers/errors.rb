module Carpanta
  module Domain
    module Customers
      module Errors
        class Invalid < StandardError ; end
        class EmailNotUnique < StandardError ; end
        class NotFound < StandardError ; end
      end
    end
  end
end
