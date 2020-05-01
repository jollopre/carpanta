require 'forwardable'
require_relative 'customer'
require_relative 'errors'
require_relative 'repository'

module Carpanta
  module Domain
    module Customers
      class Service
        class << self
          extend Forwardable

          def create!(attributes)
            customer = Customer.build(attributes)

            raise Errors::Invalid unless customer.errors.empty?

            raise Errors::EmailNotUnique if Repository.exists?(customer)

            Repository.create!(customer)
          end

          def_delegators Repository, :find_all, :find_by_id!
        end
      end
    end
  end
end
