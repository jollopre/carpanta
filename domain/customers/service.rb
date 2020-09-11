require 'forwardable'
require_relative 'customer'
require_relative 'errors'
require_relative 'repository_legacy'

module Carpanta
  module Domain
    module Customers
      class Service
        class << self
          extend Forwardable

          def save!(attributes)
            customer = Customer.build(attributes)

            raise Errors::Invalid unless customer.errors.empty?

            raise Errors::EmailNotUnique if RepositoryLegacy.exists?(customer)

            RepositoryLegacy.save!(customer)

            customer
          end

          def_delegators RepositoryLegacy, :find_by_id!
        end
      end
    end
  end
end
