require_relative 'customer'
require_relative 'customer_errors'
require_relative 'customer_repository'

module Carpanta
  module Domain
    module Customers
      class CustomerService
        class << self
          def create!(attributes)
            customer = Customer.from_params(attributes)

            raise InvalidCustomer unless customer.errors.empty?

            raise EmailNotUnique if CustomerRepository.exists?(customer)

            CustomerRepository.create!(customer)
          end
        end
      end
    end
  end
end
