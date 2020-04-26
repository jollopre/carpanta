require_relative 'customer'
require_relative 'errors'
require_relative 'repository'

module Carpanta
  module Domain
    module Customers
      class Service
        class << self
          def create!(attributes)
            customer = Customer.build(attributes)

            raise Errors::Invalid unless customer.errors.empty?

            raise Errors::EmailNotUnique if Repository.exists?(customer)

            Repository.create!(customer)
          end

          def find_all
            Repository.find_all
          end

          def find_by_id(id)
            Repository.find_by_id(id)
          end
        end
      end
    end
  end
end
