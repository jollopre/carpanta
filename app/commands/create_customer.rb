require 'domain/shared/callable'
require 'domain/customers/create_customer_service'

module Carpanta
  module Commands
    class CreateCustomer
      extend Domain::Shared::Callable

      def call(params = {})
        Domain::Customers::CreateCustomerService.call(params)
      end
    end
  end
end
