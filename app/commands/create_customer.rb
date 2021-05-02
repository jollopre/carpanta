require "domain/shared/callable"
require "domain/customers/services/create_customer"

module Carpanta
  module Commands
    class CreateCustomer
      extend Domain::Shared::Callable

      def call(params = {})
        Domain::Customers::Services::CreateCustomer.call(params)
      end
    end
  end
end
