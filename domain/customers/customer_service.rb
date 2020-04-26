require_relative 'customer'
require_relative 'errors'
require_relative 'customer_repository'

module Carpanta
  module Domain
    module Customers
      class CustomerService
        class << self
          def create!(attributes)
            customer = Customer.build(attributes)

            raise Errors::Invalid unless customer.errors.empty?

            raise Errors::EmailNotUnique if CustomerRepository.exists?(customer)

            CustomerRepository.create!(customer)
          end

          def find_all
            CustomerRepository.find_all
          end

          def find_by_id(id)
            CustomerRepository.find_by_id(id)
          end
        end
      end
    end
  end
end
