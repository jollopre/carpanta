require 'domain/customers/services/create_customer'

module Carpanta
  module Commands
    class CreateCustomer
      class << self
        def call(customer_attributes)
          #Domain::Customers::Services::CreateCustomer.call(customer_attributes)
        end
      end
    end
  end
end
